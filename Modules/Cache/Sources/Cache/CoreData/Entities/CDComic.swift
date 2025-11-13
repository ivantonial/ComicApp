//
//  CDComic.swift
//  Cache
//
//  Created by Ivan Tonial IP.TV on 09/10/25.
//

import ComicVineAPI
import CoreData
import Foundation

@objc(CDComic)
public class CDComic: NSManagedObject {
    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var comicDescription: String?
    @NSManaged public var thumbnailPath: String?
    @NSManaged public var characterId: Int32
    @NSManaged public var cachedAt: Date?

    /// Mesma ideia do CDCharacter: por enquanto não reconstruímos um `Comic`
    /// completo do cache para evitar depender de inits internos de `ComicVineImage`.
    func toComic() -> Comic? {
        return nil
    }

    func update(from comic: Comic, characterId: Int) {
        id = Int32(comic.id)
        title = comic.title
        comicDescription = comic.description

        // Guardamos a melhor URL da imagem como string
        thumbnailPath = comic.image.bestQualityUrl?.absoluteString

        self.characterId = Int32(characterId)
        cachedAt = Date()
    }
}

extension CDComic {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDComic> {
        NSFetchRequest<CDComic>(entityName: "CDComic")
    }

    static func entityDescription() -> NSEntityDescription {
        let e = NSEntityDescription()
        e.name = "CDComic"
        e.managedObjectClassName = NSStringFromClass(CDComic.self)
        e.properties = [
            CoreDataStack.cdMakeAttribute(name: "id", type: .integer32AttributeType, optional: false),
            CoreDataStack.cdMakeAttribute(name: "title", type: .stringAttributeType),
            CoreDataStack.cdMakeAttribute(name: "comicDescription", type: .stringAttributeType),
            CoreDataStack.cdMakeAttribute(name: "thumbnailPath", type: .stringAttributeType),
            CoreDataStack.cdMakeAttribute(name: "characterId", type: .integer32AttributeType),
            CoreDataStack.cdMakeAttribute(name: "cachedAt", type: .dateAttributeType)
        ]
        return e
    }
}
