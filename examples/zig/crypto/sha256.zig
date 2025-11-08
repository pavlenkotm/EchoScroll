// Zig Cryptography - SHA-256 Implementation
// Modern systems programming language for Web3
const std = @import("std");
const crypto = std.crypto;

const Secp256k1 = crypto.sign.ecdsa.Secp256k1;
const Sha256 = crypto.hash.sha2.Sha256;

pub const Wallet = struct {
    private_key: [32]u8,
    public_key: [33]u8,
    address: [20]u8,

    pub fn generate() !Wallet {
        var prng = std.rand.DefaultPrng.init(blk: {
            var seed: u64 = undefined;
            try std.os.getrandom(std.mem.asBytes(&seed));
            break :blk seed;
        });

        const rand = prng.random();

        var private_key: [32]u8 = undefined;
        rand.bytes(&private_key);

        return Wallet{
            .private_key = private_key,
            .public_key = undefined,
            .address = undefined,
        };
    }

    pub fn signMessage(self: *const Wallet, message: []const u8, allocator: std.mem.Allocator) ![]u8 {
        var hash: [32]u8 = undefined;
        Sha256.hash(message, &hash, .{});

        // In production, use proper secp256k1 signing
        const signature = try allocator.alloc(u8, 65);
        std.mem.copy(u8, signature, &hash);

        return signature;
    }
};

pub fn keccak256(data: []const u8) [32]u8 {
    var hasher = crypto.hash.sha3.Keccak256.init(.{});
    hasher.update(data);
    var hash: [32]u8 = undefined;
    hasher.final(&hash);
    return hash;
}

pub fn sha256Hash(data: []const u8) [32]u8 {
    var hash: [32]u8 = undefined;
    Sha256.hash(data, &hash, .{});
    return hash;
}

pub fn hexEncode(bytes: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const hex_chars = "0123456789abcdef";
    const result = try allocator.alloc(u8, bytes.len * 2);

    for (bytes, 0..) |byte, i| {
        result[i * 2] = hex_chars[byte >> 4];
        result[i * 2 + 1] = hex_chars[byte & 0x0F];
    }

    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();

    // Test SHA-256
    const message = "Hello, Zig!";
    const hash = sha256Hash(message);
    const hex = try hexEncode(&hash, allocator);
    defer allocator.free(hex);

    try stdout.print("Message: {s}\n", .{message});
    try stdout.print("SHA-256: 0x{s}\n", .{hex});

    // Test Keccak-256
    const keccak = keccak256(message);
    const keccak_hex = try hexEncode(&keccak, allocator);
    defer allocator.free(keccak_hex);

    try stdout.print("Keccak-256: 0x{s}\n", .{keccak_hex});

    // Generate wallet
    try stdout.print("\n--- Wallet Generation ---\n", .{});
    const wallet = try Wallet.generate();

    const priv_hex = try hexEncode(&wallet.private_key, allocator);
    defer allocator.free(priv_hex);

    try stdout.print("Private Key: 0x{s}\n", .{priv_hex});
}
