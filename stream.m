
- (unsigned char*) getStream {
    NSInputStream* stream = [NSInputStream inputStreamWithFileAtPath: path];
    // �G���[������������NULL��Ԃ�
    if (stream == nil) {
        //NSLog(@"�C���X�^���X�����s");
        return NULL;
    }

    long count = 0;
    [stream open];
    do {
        count = [stream read: buffer maxLength:BUFFER_SIZE_FOR_READ];
        //NSLog(@"�ǂݍ��݌��� %3d", (int)count);
        if (count > 0) {
            
        }
    } while ([stream hasBytesAvailable]);
     
    [stream close];
    // �G���[������
    if (count < 0) {
        return NULL;
    }
}


 