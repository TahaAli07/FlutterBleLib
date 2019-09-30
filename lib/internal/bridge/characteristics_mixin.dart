part of internal_bridge_lib;

mixin CharacteristicsMixin on FlutterBLE {
  final EventChannel _monitoringChannel =
      const EventChannel(ChannelName.monitorCharacteristic);

  Future<Uint8List> readCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod(
            MethodName.readCharacteristicForIdentifier,
            <String, dynamic>{
              ArgumentName.characteristicIdentifier: characteristicIdentifier,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then((rawJsonValue) =>
              _parseCharacteristicResponse(peripheral, rawJsonValue).value);

  Future<CharacteristicWithValue> readCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUUID,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod(
            MethodName.readCharacteristicForDevice,
            <String, dynamic>{
              ArgumentName.deviceIdentifier: peripheral.identifier,
              ArgumentName.serviceUuid: serviceUuid,
              ArgumentName.characteristicUuid: characteristicUUID,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then(
            (rawJsonValue) =>
                _parseCharacteristicResponse(peripheral, rawJsonValue),
          );

  Future<CharacteristicWithValue> readCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod(
            MethodName.readCharacteristicForService,
            <String, dynamic>{
              ArgumentName.serviceIdentifier: serviceIdentifier,
              ArgumentName.characteristicUuid: characteristicUUID,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then(
            (rawJsonValue) =>
                _parseCharacteristicResponse(peripheral, rawJsonValue),
          );

  Future<void> writeCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    Uint8List bytes,
    bool withResponse,
    String transactionId,
  ) =>
      _methodChannel.invokeMethod(
        MethodName.writeCharacteristicForIdentifier,
        <String, dynamic>{
          ArgumentName.characteristicIdentifier: characteristicIdentifier,
          ArgumentName.bytes: bytes,
          ArgumentName.withResponse: withResponse,
          ArgumentName.transactionId: transactionId,
        },
      ).catchError((errorJson) =>
          Future.error(BleError.fromJson(jsonDecode(errorJson.details))));

  Future<Characteristic> writeCharacteristicForDevice(
          Peripheral peripheral,
          String serviceUUID,
          String characteristicUUID,
          Uint8List bytes,
          bool withResponse,
          String transactionId) =>
      _methodChannel
          .invokeMethod(
            MethodName.writeCharacteristicForDevice,
            <String, dynamic>{
              ArgumentName.deviceIdentifier: peripheral.identifier,
              ArgumentName.serviceUuid: serviceUUID,
              ArgumentName.characteristicUuid: characteristicUUID,
              ArgumentName.bytes: bytes,
              ArgumentName.withResponse: withResponse,
              ArgumentName.transactionId: transactionId,
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then(
            (rawJsonValue) =>
                _parseCharacteristicResponse(peripheral, rawJsonValue),
          );

  Future<Characteristic> writeCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod(
            MethodName.writeCharacteristicForService,
            <String, dynamic>{
              ArgumentName.serviceIdentifier: serviceIdentifier,
              ArgumentName.characteristicUuid: characteristicUUID,
              ArgumentName.bytes: bytes,
              ArgumentName.withResponse: withResponse,
              ArgumentName.transactionId: transactionId,
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then(
            (rawJsonValue) =>
                _parseCharacteristicResponse(peripheral, rawJsonValue),
          );

  Stream<Uint8List> monitorCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    String transactionId,
  ) async* {
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForIdentifier,
      <String, dynamic>{
        ArgumentName.characteristicIdentifier: characteristicIdentifier,
        ArgumentName.transactionId: transactionId,
      },
    );
    yield* _monitoringChannel
        .receiveBroadcastStream()
        .map(
          (rawJsonValue) =>
              _parseCharacteristicResponse(peripheral, rawJsonValue),
        )
        .map((characteristicWithValue) => characteristicWithValue.value)
        .handleError((errorJson) =>
            throw BleError.fromJson(jsonDecode(errorJson.details)));
  }

  Stream<CharacteristicWithValue> monitorCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUUID,
    String transactionId,
  ) async* {
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForDevice,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
        ArgumentName.serviceUuid: serviceUuid,
        ArgumentName.characteristicUuid: characteristicUUID,
        ArgumentName.transactionId: transactionId,
      },
    );
    yield* _monitoringChannel
        .receiveBroadcastStream()
        .map(
          (rawJsonValue) =>
              _parseCharacteristicResponse(peripheral, rawJsonValue),
        )
        .handleError((errorJson) =>
            throw BleError.fromJson(jsonDecode(errorJson.details)));
  }

  Stream<CharacteristicWithValue> monitorCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID,
    String transactionId,
  ) async* {
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForService,
      <String, dynamic>{
        ArgumentName.serviceIdentifier: serviceIdentifier,
        ArgumentName.characteristicUuid: characteristicUUID,
        ArgumentName.transactionId: transactionId,
      },
    );
    yield* _monitoringChannel
        .receiveBroadcastStream()
        .map(
          (rawJsonValue) =>
              _parseCharacteristicResponse(peripheral, rawJsonValue),
        )
        .handleError((errorJson) =>
            throw BleError.fromJson(jsonDecode(errorJson.details)));
  }

  CharacteristicWithValue _parseCharacteristicResponse(
      Peripheral peripheral, rawJsonValue) {
    Map<String, dynamic> rootObject = jsonDecode(rawJsonValue);
    Service service = Service.fromJson(rootObject, peripheral, _manager);

    return CharacteristicWithValue.fromJson(
        rootObject["characteristic"], service, _manager);
  }
}
