//
//  CDCharacter.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import CoreData
import Foundation
import ComicVineAPI

@objc(CDCharacter)
public class CDCharacter: NSManagedObject {
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var characterDescription: String?
    @NSManaged public var thumbnailPath: String?
    @NSManaged public var comicsCount: Int32
    @NSManaged public var seriesCount: Int32
    @NSManaged public var storiesCount: Int32
    @NSManaged public var eventsCount: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var cachedAt: Date?

    /// Por enquanto, não reconstruímos o `Character` completo a partir do cache,
    /// pois o `ComicVineImage` não expõe um init público.
    /// Se for necessário no futuro, dá pra:
    ///  - expor um init público em `ComicVineImage` no módulo ComicVineAPI, ou
    ///  - guardar mais metadados aqui e montar um `Character` mínimo.
    func toCharacter() -> ComicVineAPI.Character? {
        return nil
    }

    /// Atualiza os campos do CoreData a partir de um `ComicVineAPI.Character`
    /// (já no modelo novo da ComicVine, sem Marvel).
    func update(from character: Character, isFavorite: Bool = false) {
        id = Int32(character.id)
        name = character.name
        characterDescription = character.description

        // Guardamos a melhor URL da imagem como string
        thumbnailPath = character.image.bestQualityUrl?.absoluteString

        // ComicVine: total de aparições
        comicsCount = Int32(character.countOfIssueAppearances)

        // ComicVine: quantos volumes/séries relacionados
        seriesCount = Int32(character.volumeCredits?.count ?? 0)

        // ComicVine: quantas issues/créditos de edição
        storiesCount = Int32(character.issueCredits?.count ?? 0)

        // ComicVine: quantos inimigos (reaproveitando campo "events" como algo relevante)
        eventsCount = Int32(character.characterEnemies?.count ?? 0)

        self.isFavorite = isFavorite
        lastUpdated = Date()
        cachedAt = Date()
    }
}

extension CDCharacter {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDCharacter> {
        NSFetchRequest<CDCharacter>(entityName: "CDCharacter")
    }

    static func entityDescription() -> NSEntityDescription {
        let e = NSEntityDescription()
        e.name = "CDCharacter"
        e.managedObjectClassName = NSStringFromClass(CDCharacter.self)
        e.properties = [
            CoreDataStack.cdMakeAttribute(name: "id", type: .integer32AttributeType, optional: false),
            CoreDataStack.cdMakeAttribute(name: "name", type: .stringAttributeType),
            CoreDataStack.cdMakeAttribute(name: "characterDescription", type: .stringAttributeType),
            CoreDataStack.cdMakeAttribute(name: "thumbnailPath", type: .stringAttributeType),
            CoreDataStack.cdMakeAttribute(name: "comicsCount", type: .integer32AttributeType),
            CoreDataStack.cdMakeAttribute(name: "seriesCount", type: .integer32AttributeType),
            CoreDataStack.cdMakeAttribute(name: "storiesCount", type: .integer32AttributeType),
            CoreDataStack.cdMakeAttribute(name: "eventsCount", type: .integer32AttributeType),
            CoreDataStack.cdMakeAttribute(name: "isFavorite", type: .booleanAttributeType),
            CoreDataStack.cdMakeAttribute(name: "lastUpdated", type: .dateAttributeType),
            CoreDataStack.cdMakeAttribute(name: "cachedAt", type: .dateAttributeType)
        ]
        return e
    }
}
