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
    @NSManaged public var friendsCount: Int32
    @NSManaged public var powersCount: Int32
    @NSManaged public var enemiesCount: Int32
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

        // ComicVine: total de apariÃ§Ãµes
        comicsCount = Int32(character.countOfIssueAppearances)

        // ComicVine: quantidade de amigos/aliados
        friendsCount = Int32(character.characterFriends?.count ?? 0)

        // ComicVine: quantidade de poderes/habilidades
        powersCount = Int32(character.powers?.count ?? 0)

        // Aqui reaproveitamos para algo relevante“ ex: quantidade de inimigos
        enemiesCount = Int32(character.characterEnemies?.count ?? 0)

        // altera o favorito se um valor foi passado (preserva estado atual se nil)
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

    /// Reconstrui um `Character` a partir dos dados salvos no cache
    /// Usa o metodo helper `makeFromCache` para criar um Character basico
    public func toCharacter() -> ComicVineAPI.Character? {
        // Verificar se temos os dados mÃ­nimos necessarios
        guard let name = self.name else {
            print("âš ï¸ [CDCharacter] Cannot convert to Character: missing name")
            return nil
        }

        // Formatar as datas para o formato esperado pela ComicVine
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let dateAdded = lastUpdated != nil ? dateFormatter.string(from: lastUpdated!) : nil
        let dateUpdated = cachedAt != nil ? dateFormatter.string(from: cachedAt!) : nil

        // Usar o metodo helper para criar o Character
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

    /// Se voce estiver criando o modelo de forma programatica,
    /// essa descricao de entidade ajuda a montar o `NSPersistentStore`.
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
            CoreDataStack.cdMakeAttribute(name: "friendsCount", type: .integer32AttributeType),
            CoreDataStack.cdMakeAttribute(name: "powersCount", type: .integer32AttributeType),
            CoreDataStack.cdMakeAttribute(name: "enemiesCount", type: .integer32AttributeType),
            CoreDataStack.cdMakeAttribute(name: "isFavorite", type: .booleanAttributeType),
            CoreDataStack.cdMakeAttribute(name: "lastUpdated", type: .dateAttributeType),
            CoreDataStack.cdMakeAttribute(name: "cachedAt", type: .dateAttributeType)
        ]
        return e
    }
}








