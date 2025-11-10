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

    // MARK: - Stored Properties (Core Data)

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

    // MARK: - Bridge API -> Cache

    /// Atualiza os campos do CoreData a partir de um `ComicVineAPI.Character`
    /// (modelo novo da ComicVine).
    public func update(from character: ComicVineAPI.Character,
                       isFavorite: Bool? = nil,
                       now: Date = Date()) {
        id = Int32(character.id)
        name = character.name
        characterDescription = character.description

        // Guardamos a melhor URL da imagem como string
        // (propriedade definida no módulo ComicVineAPI, em `ComicVineImage`)
        thumbnailPath = character.image.bestQualityUrl?.absoluteString

        // ComicVine: total de aparições
        comicsCount = Int32(character.countOfIssueAppearances)

        // ComicVine: quantos volumes/séries relacionados
        seriesCount = Int32(character.volumeCredits?.count ?? 0)

        // ComicVine: quantas issues/créditos de edição
        storiesCount = Int32(character.issueCredits?.count ?? 0)

        // Aqui reaproveitamos para algo “relevante” – ex: quantidade de inimigos
        eventsCount = Int32(character.characterEnemies?.count ?? 0)

        // Só altera o favorito se um valor foi passado (preserva estado atual se nil)
        if let isFavorite {
            self.isFavorite = isFavorite
        }

        // Datas de controle interno do cache
        lastUpdated = now
        if cachedAt == nil {
            cachedAt = now
        }
    }

    // MARK: - Bridge Cache -> API

    /// Reconstrói um `Character` a partir dos dados salvos no cache
    /// Usa o método helper `makeFromCache` para criar um Character básico
    public func toCharacter() -> ComicVineAPI.Character? {
        // Verificar se temos os dados mínimos necessários
        guard let name = self.name else {
            print("⚠️ [CDCharacter] Cannot convert to Character: missing name")
            return nil
        }

        // Formatar as datas para o formato esperado pela ComicVine
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateAdded = lastUpdated != nil ? dateFormatter.string(from: lastUpdated!) : nil
        let dateUpdated = cachedAt != nil ? dateFormatter.string(from: cachedAt!) : nil

        // Usar o método helper para criar o Character
        let character = Character.makeFromCache(
            id: Int(id),
            name: name,
            description: characterDescription,
            thumbnailPath: thumbnailPath,
            comicsCount: Int(comicsCount),
            dateAdded: dateAdded,
            dateLastUpdated: dateUpdated
        )

        return character
    }
}

// MARK: - Core Data helpers

extension CDCharacter {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDCharacter> {
        return NSFetchRequest<CDCharacter>(entityName: "CDCharacter")
    }

    /// Se você estiver criando o modelo de forma programática,
    /// essa descrição de entidade ajuda a montar o `NSPersistentStore`.
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
