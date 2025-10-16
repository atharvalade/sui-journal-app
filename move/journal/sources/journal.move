module journal::journal {
    use std::string::String;
    use sui::clock::Clock;

    /// A journal owned by a user that contains entries
    public struct Journal has key, store {
        id: UID,
        owner: address,
        title: String,
        entries: vector<Entry>,
    }

    /// A journal entry with content and timestamp
    public struct Entry has store {
        content: String,
        create_at_ms: u64,
    }

    /// Create a new journal with the given title
    public fun new_journal(title: String, ctx: &mut TxContext): Journal {
        Journal {
            id: object::new(ctx),
            owner: ctx.sender(),
            title,
            entries: vector::empty(),
        }
    }

    /// Add a new entry to an existing journal
    public fun add_entry(
        journal: &mut Journal,
        content: String,
        clock: &Clock,
        ctx: &TxContext,
    ) {
        // Verify the caller is the journal owner
        assert!(journal.owner == ctx.sender(), 0);

        // Create new entry with timestamp
        let entry = Entry {
            content,
            create_at_ms: clock.timestamp_ms(),
        };

        // Add entry to journal
        journal.entries.push_back(entry);
    }
}
