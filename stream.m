
- (unsigned char*) getStream {
    NSInputStream* stream = [NSInputStream inputStreamWithFileAtPath: path];
    // エラーが発生したらNULLを返す
    if (stream == nil) {
        //NSLog(@"インスタンス化失敗");
        return NULL;
    }

    long count = 0;
    [stream open];
    do {
        count = [stream read: buffer maxLength:BUFFER_SIZE_FOR_READ];
        //NSLog(@"読み込み結果 %3d", (int)count);
        if (count > 0) {
            
        }
    } while ([stream hasBytesAvailable]);
     
    [stream close];
    // エラー発生時
    if (count < 0) {
        return NULL;
    }
}


 