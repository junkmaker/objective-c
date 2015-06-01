(void)method
{
	// オペレーションキュー作成
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	queue.maxConcurrentOperationCount = 1;	// 実行数制限
	
	// ブロックタスクを作成
	NSBlockOperation *operation = [[NSBlockOperation alloc] init];
	[operation addExecutionBlock:^ {
		// 並行処理
		[NSThread sleepForTimeInterval:5];
		// メインスレッドでビューを更新する
		[self performSelectorOnMainThread: @selector(someMethodSelector) withObject:nil waitUntilDone:NO];
	}];
	[queue addOperation:operation];
	// 終了時処理
    [operation setCompletionBlock:^{
        NSLog(@"end");
		// ブロックからアプリケーション終了可能？
		[NSApp terminate:self]
    }];
	//実行
    [operation start];
}