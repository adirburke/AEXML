//
//  AEXML+extensions.swift
//  RMSServer
//
//  Created by WorkDesk on 25/11/19.
//

import Foundation

public extension AEXMLElement {
    
    var oldestParent: AEXMLElement {
        var element = self
        
        while let parent = element.parent {
            element = parent
        }
        
        return element
    }
    
    func addNameSpace(name: String, uri : String) {
        namespaces[name] = uri
        namespacesUri[uri] = name
        lastestNampace = name
    }
    
    func checkNameSpace(forName: String) -> Bool {
        return namespaces[forName] == nil ? true : false
    }
    
    func checkNameSpaceUri(forUri: String) -> Bool {
        return namespacesUri[forUri] == nil ? true : false
    }
    
    func getNameSpace(forUri : String ) -> String? {
        return namespacesUri[forUri]
    }
    func getNameSpace(forName : String ) -> String? {
        return namespaces[forName]
    }
    
    func makeChildNode(nameSpaceName: String, uri : String) -> AEXMLElement{
         let old = self.oldestParent
        let node : AEXMLElement
        if let nameSpace = old.getNameSpace(forUri: uri) {
            //                let name = ["xmlns:\(nameSpace)"]
            node = self.addChild(name: "\(nameSpace):\(nameSpaceName)")
        } else {
            let nameSpace : String
            let last = old.lastestNampace
            let lastChar = last.last?.wholeNumberValue
        
            if let int = lastChar {
                let newInt = int + 1
                nameSpace = "\(last.dropLast())\(newInt)"
            } else {
                nameSpace = "ns0"
            }
            let name = ["xmlns:\(nameSpace)" : uri]
            self.attributes = self.attributes.merging(name){ (_, new) in new}
    //        node = self.addChild(name: "\(nameSpace):\(nameSpaceName)", value: nil, attributes: name)
            node = self.addChild(name: "\(nameSpace):\(nameSpaceName)")
            old.addNameSpace(name: nameSpace, uri: uri)
            
        }
        return node
    }
}
