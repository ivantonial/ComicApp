//
//  CharacterSummaryModel.swift
//  ComicVineAPI
//
//  Created by Ivan Tonial IP.TV on 13/10/25.
//

import Foundation

public struct CharacterSummaryModel: Sendable {
    public let id: Int
    public let name: String
    public let imageURL: URL?
    public let comicsCount: Int

    public init(from character: Character) {
        self.id = character.id
        self.name = character.name

        // Usa a melhor URL disponível da imagem
        self.imageURL = character.image.bestQualityUrl

        // Usa countOfIssueAppearances diretamente (não existe mais comics.available)
        self.comicsCount = character.countOfIssueAppearances
    }

    // Inicializador manual para casos específicos
    public init(
        id: Int,
        name: String,
        imageURL: URL?,
        comicsCount: Int
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.comicsCount = comicsCount
    }
}

// MARK: - Extensões úteis
public extension CharacterSummaryModel {
    /// Verifica se tem imagem disponível
    var hasImage: Bool {
        imageURL != nil
    }

    /// Texto formatado para o número de quadrinhos
    var comicsCountText: String {
        switch comicsCount {
        case 0:
            return "No comics"
        case 1:
            return "1 comic"
        default:
            return "\(comicsCount) comics"
        }
    }
}
