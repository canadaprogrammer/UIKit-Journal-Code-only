//
//  SharedData.swift
//  JRN-CodeOnly
//
//  Created by Jungjin Park on 2024-05-17.
//

import UIKit

class SharedData {
    static let shared = SharedData()
    private var journalEntries: [JournalEntry]
    
    private init() {
        journalEntries = []
    }
    
    func numberOfJournalEntries() -> Int {
        journalEntries.count
    }
    
    func getJournalEntry(index: Int) -> JournalEntry {
        journalEntries[index]
    }
    
    func getAllJournalEntries() -> [JournalEntry] {
        let readOnlyJournalEntries = journalEntries
        return readOnlyJournalEntries
    }
    
    func addJournalEntry(newJournalEntry: JournalEntry) {
        journalEntries.append(newJournalEntry)
    }
    
    func removeJournalEntry(index: Int) {
        journalEntries.remove(at: index)
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}