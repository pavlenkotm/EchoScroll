// Motoko Smart Contract for Internet Computer
// A comprehensive counter canister demonstrating Motoko's features

import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Time "mo:base/Time";
import Principal "mo:base/Principal";

actor Counter {
    // Stable variables persist across canister upgrades
    stable var counter : Nat = 0;
    stable var owner : Principal = Principal.fromText("aaaaa-aa");
    stable var lastUpdated : Int = 0;

    // Volatile variable - reset on upgrade
    var callCount : Nat = 0;

    // History tracking (limited to last 10 entries)
    stable var history : [CounterEntry] = [];

    // Custom type definition
    type CounterEntry = {
        value : Nat;
        timestamp : Int;
        caller : Principal;
    };

    // Error types
    type Error = {
        #NotOwner;
        #Overflow;
        #Underflow;
    };

    // Initialize canister
    system func preupgrade() {
        // Called before upgrade - save volatile state if needed
    };

    system func postupgrade() {
        // Called after upgrade - restore volatile state if needed
    };

    // Query function - fast, read-only
    public query func get() : async Nat {
        return counter;
    };

    // Query function - get counter with metadata
    public query func getInfo() : async {
        value : Nat;
        lastUpdated : Int;
        callCount : Nat;
    } {
        return {
            value = counter;
            lastUpdated = lastUpdated;
            callCount = callCount;
        };
    };

    // Public update function - increment counter
    public shared(msg) func increment() : async Nat {
        // Check for overflow
        if (counter >= 1_000_000_000) {
            return counter;  // Prevent overflow
        };

        counter += 1;
        callCount += 1;
        lastUpdated := Time.now();

        // Add to history
        addToHistory({
            value = counter;
            timestamp = Time.now();
            caller = msg.caller;
        });

        return counter;
    };

    // Decrement counter
    public shared(msg) func decrement() : async Nat {
        // Check for underflow
        if (counter == 0) {
            return counter;
        };

        counter -= 1;
        callCount += 1;
        lastUpdated := Time.now();

        addToHistory({
            value = counter;
            timestamp = Time.now();
            caller = msg.caller;
        });

        return counter;
    };

    // Set counter to specific value (owner only)
    public shared(msg) func set(newValue : Nat) : async Result.Result<Nat, Error> {
        if (msg.caller != owner) {
            return #err(#NotOwner);
        };

        counter := newValue;
        lastUpdated := Time.now();
        callCount += 1;

        addToHistory({
            value = counter;
            timestamp = Time.now();
            caller = msg.caller;
        });

        return #ok(counter);
    };

    // Reset counter (owner only)
    public shared(msg) func reset() : async Result.Result<Nat, Error> {
        if (msg.caller != owner) {
            return #err(#NotOwner);
        };

        counter := 0;
        lastUpdated := Time.now();
        callCount += 1;
        history := [];

        return #ok(0);
    };

    // Get history
    public query func getHistory() : async [CounterEntry] {
        return history;
    };

    // Get last update timestamp
    public query func getLastUpdated() : async Int {
        return lastUpdated;
    };

    // Get owner
    public query func getOwner() : async Principal {
        return owner;
    };

    // Transfer ownership
    public shared(msg) func transferOwnership(newOwner : Principal) : async Result.Result<Bool, Error> {
        if (msg.caller != owner) {
            return #err(#NotOwner);
        };

        owner := newOwner;
        return #ok(true);
    };

    // Increment by custom amount
    public shared(msg) func incrementBy(amount : Nat) : async Result.Result<Nat, Error> {
        // Check for overflow
        if (counter + amount > 1_000_000_000) {
            return #err(#Overflow);
        };

        counter += amount;
        lastUpdated := Time.now();
        callCount += 1;

        addToHistory({
            value = counter;
            timestamp = Time.now();
            caller = msg.caller;
        });

        return #ok(counter);
    };

    // Get call statistics
    public query func getStats() : async {
        counter : Nat;
        totalCalls : Nat;
        historySize : Nat;
        owner : Principal;
    } {
        return {
            counter = counter;
            totalCalls = callCount;
            historySize = history.size();
            owner = owner;
        };
    };

    // Private helper function
    private func addToHistory(entry : CounterEntry) {
        // Keep only last 10 entries
        if (history.size() >= 10) {
            history := Array.tabulate<CounterEntry>(9, func(i) { history[i + 1] });
            history := Array.append(history, [entry]);
        } else {
            history := Array.append(history, [entry]);
        };
    };

    // Batch increment
    public shared(msg) func batchIncrement(count : Nat) : async Result.Result<Nat, Error> {
        if (counter + count > 1_000_000_000) {
            return #err(#Overflow);
        };

        counter += count;
        lastUpdated := Time.now();
        callCount += 1;

        return #ok(counter);
    };

    // Check if caller is owner
    public shared(msg) func isOwner() : async Bool {
        return msg.caller == owner;
    };
};
