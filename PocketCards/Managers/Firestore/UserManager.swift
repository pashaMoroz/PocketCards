//
//  UserManager2.swift
//  Unison
//
//  Created by Moroz Pavlo on 2023-06-22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


enum AnswerScale: Int, Codable {
    case negativeOne = -1
    case zero = 0
    case one = 1
}

struct Questionnaire: Codable {
    let answers: [String : AnswerScale]?
}

struct DatabaseUser: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?
    let dataCreated: Date?
    let isPremium: Bool?
    let bio: String?
    let questionnaire: [Questionnaire]?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dataCreated = Date()
        self.isPremium = false
        self.bio = nil
        self.questionnaire = nil
    }
}


final class UserManager {
    
    private let userCollection: CollectionReference =  Firestore.firestore().collection("users")
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func getUser(userId: String) async throws -> DatabaseUser {
        try await userDocument(userId: userId).getDocument(as: DatabaseUser.self)
    }
    
    func createNewUserIfNeeded(user: DatabaseUser) async throws {
        let documentRef = userDocument(userId: user.userId)
        
        let document = try await documentRef.getDocument()
        if !document.exists {
            try documentRef.setData(from: user, merge: false)
        }
        
    }
}


//MARK: - Delete user document when account was deleted
extension UserManager {
    
    func deleteUserDocument(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
    
}
