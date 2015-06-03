@interface Concurrency : NSObject
@property (nonatomic, retain) NSOperationQueue *myQueue;
@end

@implementation Concurrency
+ (void)initialize
{
	static BOOL initialized = NO;
	if(!initialized)
	{
		initialized = YES;
		// オペレーションキュー生成
		myQueue = [[NSOperationQueue alloc] init];
	}
}

- (void)dealloc
{
	[myQueue release];
	[super dealloc];
}

(void)start
{
	NSInvocationOperation *operation;
	operation = [[NSInvocationOperation alloc] initWithTarget:self
			                                         selector:@selector(next:)
			                                           object:nil];
	[myQueue addOperation:operation];
	[operation release];
}

- (void)next:(id)object
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[self performSelectorOnMainThread:@selector(end:)
	           			   withObject:nil
	        			waitUntilDone:NO];
	
	[pool release];
}

- (void)end:(id)object
{
	
}
@end