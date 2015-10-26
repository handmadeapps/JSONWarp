SCL JSON Warp
====================

An Objective-C

JSON -> Core Data

Core Data- > JSON

serializer.

# Raison d'être

There is already a big list of similar projects. So what's the reason for another one?

JSON Warp will be of help to you if (like me), you have a need to persist arbitrary JSON graphs while preserving their hierarchy.  

JSON Warp is meant to work with *arbitrary* structures and as such it assumes you know the schema beforehand.

Specifically: 

- It does not require you to define a Core Data model to host the JSON serialization.
- It does not come bundled with some other extraneous API (e.g. REST handling).
- It is very simple to use, serving only one simple purpose - storing a JSON hierarchy into Core Data and vice-versa.
- You can retrieve a whole or partial (leaf) JSON from Core Data.
- You can also walk the Core Data hierarchy itself, take advantage of faulting and directly modify the data.

# Usage

**Important!**
JSON Warp automatically wraps source JSON into a top-level "Root" object in order to be able to provide a single entry point to the graph.

**SCLJSONNode** is a subclass of *NSManagedObject* with extras to allow you to navigate the Core Data Graph.

An SCLJSONNode is deemed to be either of three types:

1. key:simpleton value (NSString, NSNumber, etc.)
2. key:JSON Object (dictionary)
3. key:JSON Object (array of JSON objects)

An SCLJSONNode always has a key. 

The value of the `value` field is nil in cases (2),(3). In these cases the value of the node is the relationship field `object`. 

This can be either a one-to-one relationship (case 2) or a one-to-many relationship (case 3).


Follow these steps to use the classes:

- Copy the classes in the `SCLJSONWarp` sub-folder into your project.

- In your Core Data Stack model initialization, merge the JSON Warp model by calling the static method: `[SCLJSONWarp sclAugmentedModelUsingBaseModel:yourCoreDataModel]`. This method will return a new merged model.

- `#import "SCLJSONWarp.h"`

- Obtain an instance using your managed object context: `SCLJSONWarp *jsonWarp=[[SCLJSONWarp alloc] initWithManagedObjectContext:[AppDelegate instance].managedObjectContext];`

- Either obtain a root Core Data node from a URL: `SCLJSONNode *jsonGraph=[jsonWarp sclJSONNodeFromJSONURL:sampleJSONURL];`. This call transcribes the JSON obtained from the URL into Core Data.

- or obtain a root Core Data node from an existing JSON object: `SCLJSONNode *jsonGraph]=[jsonWarp sclJSONNodeFromJSON:jsonObject];`. This call transcribes the JSON obtained from the URL into Core Data.

- Obtain a dictionary representation from an SCLJSONNode: `NSMutableDictionary *rootDict=[jsonWarp sclJSONNodeValueForKey:kSCLRootNodeID usingRootJSONObject:jsonGraph];`

- To obtain the value directly from a type (1) SCLJSONNode, message the SCLJSONNode using: `- (id)sclValueForNodeKey:(NSString *)keyStr`

- To obtain a child node from a type (2) SCLJSONNode, message the SCLJSONNode using: `- (SCLJSONNode *)sclNodeForNodeKey:(NSString *)keyStr`

- To obtain a child node from a type (3) SCLJSONNode, message the SCLJSONNode using: `- (SCLJSONNode *)sclNodeForNodeKey:(NSString *)keyStr` using `nil` for the `keyStr` parameter.


# The sample project

The project contains two sample JSON files and a single `ViewController` to showcase their use.

Three sample example methods are included which showcase Warp class usage and accessing the graph.

**TODO:** 

- Better examples
- Class header documentation
- More testing / debugging :)

