//
//  STViewController.m
//  TISensorTag
//
//  Created by Andre Muis on 11/14/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#define KXTJ9_RANGE 4.0

#import "STViewController.h"

@interface STViewController ()

@property (readonly, strong, nonatomic) CBCentralManager *centralManager;
@property (readonly, strong, nonatomic) NSMutableArray *peripherals;

@property (readonly, strong, nonatomic) CBUUID *temperatureSensorConfigurationUUID;
@property (readonly, strong, nonatomic) CBUUID *temperatureSensorDataUUID;

@property (readonly, strong, nonatomic) CBUUID *accelerometerConfigurationUUID;
@property (readonly, strong, nonatomic) CBUUID *accelerometerDataUUID;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerLabel;

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate: self queue: nil options: nil];
    _peripherals = [[NSMutableArray alloc] init];
    
    _temperatureSensorConfigurationUUID = [CBUUID UUIDWithString: @"f000aa02-0451-4000-b000-000000000000"];
    _temperatureSensorDataUUID = [CBUUID UUIDWithString: @"f000aa01-0451-4000-b000-000000000000"];
    
    _accelerometerConfigurationUUID = [CBUUID UUIDWithString: @"f000aa11-0451-4000-b000-000000000000"];
    _accelerometerDataUUID = [CBUUID UUIDWithString: @"f000aa12-0451-4000-b000-000000000000"];
    _accelerometerDataUUID = [CBUUID UUIDWithString: @"f000aa12-0451-4000-b000-000000000000"];
    
    [self.centralManager scanForPeripheralsWithServices: nil options: nil];
    
    self.stateLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.accelerometerLabel.backgroundColor = [UIColor clearColor];
}

- (void)centralManagerDidUpdateState: (CBCentralManager *)central
{
    self.stateLabel.text = [self stringWithCentralManagerState: central.state];
}

- (void)centralManager: (CBCentralManager *)central
 didDiscoverPeripheral: (CBPeripheral *)peripheral
     advertisementData: (NSDictionary *)advertisementData
                  RSSI: (NSNumber *)RSSI
{
    if ([self.peripherals containsObject: peripheral] == NO)
    {
        [self.peripherals addObject: peripheral];
    }
    
    [self.centralManager connectPeripheral: peripheral options: nil];
    
    NSLog(@"name %@", peripheral.name);
    NSLog(@"identifier %@", [peripheral.identifier UUIDString]);
    NSLog(@"advertisementData %@", advertisementData);
    NSLog(@"RSSI %@", RSSI);
}

- (void)centralManager: (CBCentralManager *)central
  didConnectPeripheral: (CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices: nil];
}

- (void)peripheral: (CBPeripheral *)peripheral didDiscoverServices: (NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        NSLog(@"service UUID = %@", [self stringWithCBUUID: service.UUID]);
        NSLog(@"service isPrimary = %d", service.isPrimary);
        NSLog(@"service characteristics = %@", service.characteristics);
        NSLog(@"service includedServices = %@", service.includedServices);
        NSLog(@" ");
        
        [peripheral discoverCharacteristics: nil forService: service];
    }
}

- (void)peripheral: (CBPeripheral *)peripheral didDiscoverCharacteristicsForService: (CBService *)service error: (NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"characteristic UUID = %@", [self stringWithCBUUID: characteristic.UUID]);
        NSLog(@"characteristic value = %@", characteristic.value);
        NSLog(@"characteristic descriptors = %@", characteristic.descriptors);
        NSLog(@"characteristic properties = %@", [self stringWithCharacteristicProperties: characteristic.properties]);
        NSLog(@" ");
        
        if ((characteristic.properties & CBCharacteristicPropertyRead) == CBCharacteristicPropertyRead)
        {
            [peripheral readValueForCharacteristic: characteristic];
        }
        
        if ((characteristic.properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify)
        {
            [peripheral setNotifyValue: YES forCharacteristic: characteristic];
        }
        
        if ([characteristic.UUID isEqual: self.temperatureSensorConfigurationUUID] ||
            [characteristic.UUID isEqual: self.accelerometerConfigurationUUID])
        {
            uint8_t data = 0x01;
            [peripheral writeValue: [NSData dataWithBytes: &data length: 1] forCharacteristic: characteristic type: CBCharacteristicWriteWithResponse];
        }
    }
}

- (void)peripheral: (CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic: (CBCharacteristic *)characteristic error: (NSError *)error
{
    if (error)
    {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
}

- (void)peripheral: (CBPeripheral *)peripheral didUpdateValueForCharacteristic: (CBCharacteristic *)characteristic error: (NSError *)error
{
    if (error == nil)
    {
        if ([characteristic.UUID isEqual: self.temperatureSensorDataUUID] == YES)
        {
            char scratchVal[characteristic.value.length];
            int16_t ambTemp;
            [characteristic.value getBytes: &scratchVal length: characteristic.value.length];
            ambTemp = ((scratchVal[2] & 0xff) | ((scratchVal[3] << 8) & 0xff00));
            ambTemp = (float)ambTemp / 128.0;
            
            self.temperatureLabel.text = [NSString stringWithFormat: @"%.0f F", ambTemp * 9.0 / 5.0 + 32.0];
        }
        else if ([characteristic.UUID isEqual: self.accelerometerDataUUID] == YES)
        {
            char scratchVal[characteristic.value.length];
            [characteristic.value getBytes:&scratchVal length:3];
            float accelerationX = ((scratchVal[0] * 1.0) / (256 / KXTJ9_RANGE));
            
            self.accelerometerLabel.text = [NSString stringWithFormat: @"%f", accelerationX];
        }
        
        NSLog(@"characteristic UUID = %@", [self stringWithCBUUID: characteristic.UUID]);
        NSLog(@"data = %@", characteristic.value);
    }
    else
    {
        NSLog(@"Error updating characteristic. Error = %@", [error localizedDescription]);
    }
}

- (NSString *)stringWithCentralManagerState: (CBCentralManagerState)state
{
    switch (state)
    {
        case CBCentralManagerStateUnknown:
            return @"unknown";
            break;
            
        case CBCentralManagerStateResetting:
            return @"resetting";
            break;
            
        case CBCentralManagerStateUnsupported:
            return @"unsupported";
            break;
            
        case CBCentralManagerStateUnauthorized:
            return @"unauthorized";
            break;
            
        case CBCentralManagerStatePoweredOff:
            return @"powered off";
            break;
            
        case CBCentralManagerStatePoweredOn:
            return @"powered on";
            break;
            
        default:
            NSLog(@"Unhandled central manager state: %d", state);
            return @"";
            break;
    }
}

- (NSString *)stringWithCharacteristicProperties: (CBCharacteristicProperties)properties
{
    NSString *propertiesString = @"";
    
    if ((properties & CBCharacteristicPropertyBroadcast) == CBCharacteristicPropertyBroadcast)
    {
        propertiesString = [propertiesString stringByAppendingString: @"broadcast, "];
    }
    
    if ((properties & CBCharacteristicPropertyRead) == CBCharacteristicPropertyRead)
    {
        propertiesString = [propertiesString stringByAppendingString: @"read, "];
    }
    
    if ((properties & CBCharacteristicPropertyWriteWithoutResponse) == CBCharacteristicPropertyWriteWithoutResponse)
    {
        propertiesString = [propertiesString stringByAppendingString: @"write without response, "];
    }
    
    if ((properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite)
    {
        propertiesString = [propertiesString stringByAppendingString: @"write, "];
    }
    
    if ((properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify)
    {
        propertiesString = [propertiesString stringByAppendingString: @"notify, "];
    }
    
    if ((properties & CBCharacteristicPropertyIndicate) == CBCharacteristicPropertyIndicate)
    {
        propertiesString = [propertiesString stringByAppendingString: @"indicate, "];
    }
    
    if ((properties & CBCharacteristicPropertyAuthenticatedSignedWrites) == CBCharacteristicPropertyAuthenticatedSignedWrites)
    {
        propertiesString = [propertiesString stringByAppendingString: @"authenticated signed writes, "];
    }
    
    if ((properties & CBCharacteristicPropertyExtendedProperties) == CBCharacteristicPropertyExtendedProperties)
    {
        propertiesString = [propertiesString stringByAppendingString: @"extended properties, "];
    }
    
    if ((properties & CBCharacteristicPropertyNotifyEncryptionRequired) == CBCharacteristicPropertyNotifyEncryptionRequired)
    {
        propertiesString = [propertiesString stringByAppendingString: @"notify encryption required, "];
    }
    
    if ((properties & CBCharacteristicPropertyIndicateEncryptionRequired) == CBCharacteristicPropertyIndicateEncryptionRequired)
    {
        propertiesString = [propertiesString stringByAppendingString: @"indicate encryption required, "];
    }
    
    return propertiesString;
}

- (NSString *)stringWithCBUUID: (CBUUID *)uuid
{
    NSData *data = [uuid data];
    
    NSUInteger bytesToConvert = [data length];
    const unsigned char *uuidBytes = [data bytes];
    NSMutableString *outputString = [NSMutableString stringWithCapacity: 16];
    
    for (NSUInteger currentByteIndex = 0; currentByteIndex < bytesToConvert; currentByteIndex++)
    {
        switch (currentByteIndex)
        {
            case 3:
            case 5:
            case 7:
            case 9:
                [outputString appendFormat: @"%02x-", uuidBytes[currentByteIndex]];
                break;
                
            default:
                [outputString appendFormat: @"%02x", uuidBytes[currentByteIndex]];
        }
        
    }
    
    return outputString;
}

@end





















