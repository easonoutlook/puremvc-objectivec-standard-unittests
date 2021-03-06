//
//  FacadeTest.m
//  PureMVC_ObjectiveC
//
//  PureMVC Port to ObjectiveC by Brian Knorr <brian.knorr@puremvc.org>
//  PureMVC - Copyright(c) 2006-2008 Futurescale, Inc., Some rights reserved.
//

#import "FacadeTest.h"
#import	"Facade.h"
#import "TestCommand.h"
#import "TestVO.h"
#import "Proxy.h"
#import "Mediator.h"

@implementation FacadeTest

-(void)testGetInstance {
	id<IFacade> facade = [Facade getInstance];
	STAssertTrue(facade != nil, @"facade should not be nil");
}

-(void)testRegisterCommandAndSendNotification {
	
	// Create the Facade, register the TestCommand to 
	// handle 'FacadeTest' notifications
	id<IFacade> facade = [Facade getInstance];
	[facade registerCommand:@"FacadeTestNote" commandClassRef:[TestCommand class]];
	
	// Send notification. The Command associated with the event
	// (TestCommand) will be invoked, and will multiply 
	// the vo.input value by 2 and set the result on vo.result
	TestVO *vo = [TestVO testVO];
	vo.input = 32;
	[facade sendNotification:@"FacadeTestNote" body:vo];
	
	// test assertions 
	STAssertTrue(vo.result == 64, @"result should be 64");
}

-(void)testHasAndRegisterAndRemoveCommandAndSendNotification {
	
	// Create the Facade, register the FacadeTestCommand to 
	// handle 'FacadeTest' events
	id<IFacade> facade = [Facade getInstance];
	[facade registerCommand:@"FacadeTestNote" commandClassRef:[TestCommand class]];
	STAssertTrue([facade hasCommand:@"FacadeTestNote"], @"should have FacadeTestNote");
	
	[facade removeCommand:@"FacadeTestNote"];
	
	// Send notification. The Command associated with the event
	// (FacadeTestCommand) will NOT be invoked, and will NOT multiply 
	// the vo.input value by 2 
	TestVO *vo = [TestVO testVO];
	vo.input = 32;
	[facade sendNotification:@"FacadeTestNote" body:vo];
	
	// test assertions 
	STAssertTrue(vo.result == 0, @"result should be 0");
}

-(void)testRegisterAndRetrieveProxy {
	
	// register a proxy and retrieve it.
	id<IFacade> facade = [Facade getInstance];
	
	[facade registerProxy:[Proxy withProxyName:@"colors" data:[NSArray arrayWithObjects:@"red", @"green", @"blue", nil]]];
	
	id<IProxy> proxy = [facade retrieveProxy:@"colors"];
	STAssertTrue(proxy != nil, @"proxy should not be nil");
	
	// retrieve data from proxy
	NSArray *data = [proxy data];
	
	// test assertions
	STAssertTrue(data != nil, @"Expecting data not null");
	STAssertTrue([data count] == 3, @"Expecting [data count] == 3");
	STAssertTrue([[data objectAtIndex:0] isEqualToString:@"red"], @"shoud be red");
	STAssertTrue([[data objectAtIndex:1] isEqualToString:@"green"], @"shoud be green");
	STAssertTrue([[data objectAtIndex:2] isEqualToString:@"blue"], @"shoud be blue");
}

-(void)testHasAndRegisterAndRemoveProxy {
	
	// register a proxy, remove it, then try to retrieve it
	id<IFacade> facade = [Facade getInstance];
	[facade registerProxy:[Proxy withProxyName:@"sizes" data:[NSArray arrayWithObjects:@"7", @"13", @"21", nil]]];
	
	STAssertTrue([facade hasProxy:@"sizes"], @"should have proxy sizes");
	
	// remove the proxy
	id<IProxy> proxy = [facade removeProxy:@"sizes"];
	
	// assert that we removed the appropriate proxy
	STAssertTrue([[proxy proxyName] isEqualToString:@"sizes"], @"proxyName shoud be equal to 'sizes'");
	
	// ensure that the proxy is no longer retrievable from the model
	proxy = [facade retrieveProxy:@"sizes"];
	
	// test assertions
	STAssertTrue(proxy == nil, @"Expecting proxy is null");
}

-(void)testHasAndRegisterRetrieveAndRemoveMediator {
	
	// register a mediator, remove it, then try to retrieve it
	id<IFacade> facade = [Facade getInstance];
	[facade registerMediator:[Mediator withMediatorName:@"TestMediator" viewComponent:self]];
	
	STAssertTrue([facade hasMediator:@"TestMediator"], @"should have mediator TestMediator");
	
	// Retrieve the mediator
	id<IMediator> mediator = [facade retrieveMediator:@"TestMediator"];
	STAssertTrue(mediator != nil, "mediator shounld not be nil");
	
	// remove the mediator
	mediator = [facade removeMediator:@"TestMediator"];
	
	// assert that we have removed the appropriate mediator
	STAssertTrue([[mediator mediatorName] isEqualToString:@"TestMediator"], @"name should be TestMediator");
	
	// assert that the mediator is no longer retrievable
	mediator = [facade retrieveMediator:@"TestMediator"];
	STAssertTrue(mediator == nil, "mediator shounld be nil");
	
}






@end
