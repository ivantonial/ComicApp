//
//  CDSearchHistory.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import CoreData
import Foundation

@objc(CDSearchHistory)
public class CDSearchHistory: NSManagedObject {
    @NSManaged public var query: String
    @NSManaged public var timestamp: Date
    @NSManaged public var searchedAt: Date  // Adicionado como alias para timestamp ou data específica de busca
    @NSManaged public var resultCount: Int32

    // Helper para sincronizar as datas se necessário
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        let now = Date()
        self.timestamp = now
        self.searchedAt = now
    }

    // Método para atualizar a busca mantendo consistência
    public func updateSearch(query: String, resultCount: Int32) {
        let now = Date()
        self.query = query
        self.resultCount = resultCount
        self.timestamp = now
        self.searchedAt = now
    }
}

extension CDSearchHistory {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDSearchHistory> {
        NSFetchRequest<CDSearchHistory>(entityName: "CDSearchHistory")
    }

    static func entityDescription() -> NSEntityDescription {
        let e = NSEntityDescription()
        e.name = "CDSearchHistory"
        e.managedObjectClassName = NSStringFromClass(CDSearchHistory.self)
        e.properties = [
            CoreDataStack.cdMakeAttribute(name: "query", type: .stringAttributeType),
            CoreDataStack.cdMakeAttribute(name: "timestamp", type: .dateAttributeType),
            CoreDataStack.cdMakeAttribute(name: "searchedAt", type: .dateAttributeType),  // Adicionado
            CoreDataStack.cdMakeAttribute(name: "resultCount", type: .integer32AttributeType)
        ]
        return e
    }
}
