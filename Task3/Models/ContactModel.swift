//
//  ContactModel.swift
//  Task3
//
//  Created by Вадим Сайко on 21.12.22.
//

import Contacts

final class ContactModel: Codable {
    var givenName: String
    var familyName: String
    var phoneNumber: String
    var imageData: Data?
    var isFavourite: Bool
    init(givenName: String, familyName: String, phoneNumber: String, imageData: Data?, isFavourite: Bool) {
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumber = phoneNumber
        self.imageData = imageData
        self.isFavourite = isFavourite
    }
    static func fetchContacts() -> [ContactModel] {
        let contactStore = CNContactStore()
        var contacts = [ContactModel]()
        let keys = [
            CNContactImageDataKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
        ] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
            do {
                try contactStore.enumerateContacts(with: request, usingBlock: { contact, _ in
                    let givenName = contact.givenName
                    let familyName = contact.familyName
                    let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? "No number"
                    let imageData = contact.imageData
                    let isFavourite = false
                    let contactToAppend = ContactModel(givenName: givenName,
                                                       familyName: familyName,
                                                       phoneNumber: phoneNumber,
                                                       imageData: imageData,
                                                       isFavourite: isFavourite)
                    contacts.append(contactToAppend)
                })
            } catch {
                print(error)
            }
        return contacts
    }
    static func writeContacts(forFavourites favourites: Bool) -> [ContactModel] {
        do {
            let fileURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
                .appending(path: "contacts.json")
            let data = try Data(contentsOf: fileURL)
            var contactsFromData = try JSONDecoder().decode([ContactModel].self, from: data)
            if favourites == true {
                contactsFromData = contactsFromData.filter { contactModel in
                    contactModel.isFavourite == true
                }
            }
            return contactsFromData
        } catch {
            print(error)
        }
        return []
    }
    static func saveContacts(_ contacts: [ContactModel]) {
        do {
            let fileURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
                .appending(path: "contacts.json")
            try JSONEncoder().encode(contacts).write(to: fileURL)
        } catch {
            print(error)
        }
    }
}
