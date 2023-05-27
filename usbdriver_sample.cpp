#include <os/log.h>
#include <DriverKit/IODispatchQueue.h>
#include <DriverKit/IOService.h>
#include <DriverKit/IOUSBHostDevice.h>
#include <DriverKit/IOUSBHostInterface.h>
#include <DriverKit/IOUSBHostStorageDevice.h>
#include <DriverKit/IOMemoryDescriptor.h>
#include <DriverKit/IOBufferMemoryDescriptor.h>

class USBStorageDeviceDriver : public IOService {
    OSDeclareDefaultStructors(USBStorageDeviceDriver)
public:
    virtual bool start(IOService* provider) override {
        if (!IOService::start(provider))
            return false;
        
        IOUSBHostDevice* usbDevice = OSDynamicCast(IOUSBHostDevice, provider);
        if (!usbDevice) {
            os_log_error(OS_LOG_DEFAULT, "Failed to get USB device");
            return false;
        }
        
        // USB ストレージデバイスを取得する
        IOUSBHostInterface* storageInterface = usbDevice->copyMatchingInterface(
            OSDynamicCast(IOUSBHostInterface, provider),
            kIOUSBHostMatchingOptionNone
        );
        if (!storageInterface) {
            os_log_error(OS_LOG_DEFAULT, "Failed to get USB storage interface");
            return false;
        }
        
        // SMART 属性を取得するためのコマンドを送信する
        uint8_t command[] = {
            0x4f, // READ SMART DATA
            0,    // Reserved
            0,    // Reserved
            0,    // Reserved
            0,    // Reserved
            0,    // Reserved
            0,    // Reserved
            0,    // Reserved
            0     // Control byte
        };
        
        // コマンドを実行する
        IOMemoryDescriptor* dataBuffer = IOBufferMemoryDescriptor::withOptions(
            kIODirectionIn,
            512 // SMART データのサイズに応じて適切なサイズに変更する必要があります
        );
        if (!dataBuffer) {
            os_log_error(OS_LOG_DEFAULT, "Failed to create data buffer");
            storageInterface->release();
            return false;
        }
        
        IOReturn result = storageInterface->ControlRequest(
            kIOUSBHostStandardRequestDirectionIn |
            kIOUSBHostStandardRequestTypeClass |
            kIOUSBHostStandardRequestRecipientDevice,
            0x51, // USB_MASS_STORAGE_UFI_COMMAND
            command,
            sizeof(command),
            dataBuffer,
            512, // SMART データのサイズに応じて適切なサイズに変更する必要があります
            1000 // タイムアウト時間（ミリ秒単位）
        );
        
        if (result != kIOReturnSuccess) {
            os_log_error(OS_LOG_DEFAULT, "Failed to send command: %d", result);
            dataBuffer->release();
            storageInterface->release();
            return false;
        }
        
        // SMART データを処理する（ここでは単にログに出力する）
        uint8_t* smartData = (uint8_t*)data
