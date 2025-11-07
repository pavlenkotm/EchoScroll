#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <cstring>
#include "keccak256.h"

// Keccak-256 implementation for Ethereum
// Based on the Keccak specification used in Ethereum

namespace crypto {

// Keccak round constants
static const uint64_t keccak_round_constants[24] = {
    0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808AULL,
    0x8000000080008000ULL, 0x000000000000808BULL, 0x0000000080000001ULL,
    0x8000000080008081ULL, 0x8000000000008009ULL, 0x000000000000008AULL,
    0x0000000000000088ULL, 0x0000000080008009ULL, 0x000000008000000AULL,
    0x000000008000808BULL, 0x800000000000008BULL, 0x8000000000008089ULL,
    0x8000000000008003ULL, 0x8000000000008002ULL, 0x8000000000000080ULL,
    0x000000000000800AULL, 0x800000008000000AULL, 0x8000000080008081ULL,
    0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
};

class Keccak256 {
public:
    Keccak256() {
        reset();
    }

    void reset() {
        memset(state, 0, sizeof(state));
        buffer_size = 0;
    }

    void update(const uint8_t* data, size_t length) {
        for (size_t i = 0; i < length; i++) {
            buffer[buffer_size++] = data[i];

            if (buffer_size == RATE_BYTES) {
                absorb();
                buffer_size = 0;
            }
        }
    }

    void finalize(uint8_t* hash) {
        // Padding: append 0x01, zeros, then 0x80
        buffer[buffer_size++] = 0x01;

        while (buffer_size < RATE_BYTES) {
            buffer[buffer_size++] = 0x00;
        }

        buffer[RATE_BYTES - 1] |= 0x80;

        absorb();

        // Extract hash
        for (int i = 0; i < 32; i++) {
            hash[i] = state[i];
        }
    }

private:
    static const size_t RATE_BYTES = 136; // 1088 bits / 8
    uint8_t state[200];
    uint8_t buffer[RATE_BYTES];
    size_t buffer_size;

    void absorb() {
        for (size_t i = 0; i < RATE_BYTES; i++) {
            state[i] ^= buffer[i];
        }

        keccak_f();
    }

    void keccak_f() {
        uint64_t* state64 = reinterpret_cast<uint64_t*>(state);

        for (int round = 0; round < 24; round++) {
            theta(state64);
            rho_pi(state64);
            chi(state64);
            iota(state64, round);
        }
    }

    void theta(uint64_t* A) {
        uint64_t C[5], D[5];

        for (int x = 0; x < 5; x++) {
            C[x] = A[x] ^ A[x + 5] ^ A[x + 10] ^ A[x + 15] ^ A[x + 20];
        }

        for (int x = 0; x < 5; x++) {
            D[x] = C[(x + 4) % 5] ^ rotl64(C[(x + 1) % 5], 1);
        }

        for (int x = 0; x < 5; x++) {
            for (int y = 0; y < 5; y++) {
                A[y * 5 + x] ^= D[x];
            }
        }
    }

    void rho_pi(uint64_t* A) {
        static const int rho[24] = {
            1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 2, 14,
            27, 41, 56, 8, 25, 43, 62, 18, 39, 61, 20, 44
        };

        static const int pi[24] = {
            10, 7, 11, 17, 18, 3, 5, 16, 8, 21, 24, 4,
            15, 23, 19, 13, 12, 2, 20, 14, 22, 9, 6, 1
        };

        uint64_t current = A[1];
        for (int i = 0; i < 24; i++) {
            int j = pi[i];
            uint64_t temp = A[j];
            A[j] = rotl64(current, rho[i]);
            current = temp;
        }
    }

    void chi(uint64_t* A) {
        for (int y = 0; y < 5; y++) {
            uint64_t row[5];
            for (int x = 0; x < 5; x++) {
                row[x] = A[y * 5 + x];
            }

            for (int x = 0; x < 5; x++) {
                A[y * 5 + x] = row[x] ^ ((~row[(x + 1) % 5]) & row[(x + 2) % 5]);
            }
        }
    }

    void iota(uint64_t* A, int round) {
        A[0] ^= keccak_round_constants[round];
    }

    uint64_t rotl64(uint64_t x, int n) {
        return (x << n) | (x >> (64 - n));
    }
};

std::vector<uint8_t> keccak256(const std::vector<uint8_t>& data) {
    Keccak256 hasher;
    hasher.update(data.data(), data.size());

    std::vector<uint8_t> hash(32);
    hasher.finalize(hash.data());

    return hash;
}

std::vector<uint8_t> keccak256(const std::string& str) {
    std::vector<uint8_t> data(str.begin(), str.end());
    return keccak256(data);
}

std::string to_hex(const std::vector<uint8_t>& data) {
    std::stringstream ss;
    ss << "0x";
    for (uint8_t byte : data) {
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)byte;
    }
    return ss.str();
}

} // namespace crypto

int main() {
    using namespace crypto;

    std::cout << "🔐 Keccak-256 Hash Function (Ethereum)\n\n";

    // Test 1: Hash a simple string
    std::string message1 = "Hello, Ethereum!";
    auto hash1 = keccak256(message1);

    std::cout << "Message: \"" << message1 << "\"\n";
    std::cout << "Keccak256: " << to_hex(hash1) << "\n\n";

    // Test 2: Empty string
    std::string message2 = "";
    auto hash2 = keccak256(message2);

    std::cout << "Message: \"" << message2 << "\" (empty)\n";
    std::cout << "Keccak256: " << to_hex(hash2) << "\n\n";

    // Test 3: Ethereum address derivation example
    std::string pubkey = "public_key_here";
    auto hash3 = keccak256(pubkey);

    std::cout << "Public Key: \"" << pubkey << "\"\n";
    std::cout << "Keccak256: " << to_hex(hash3) << "\n";
    std::cout << "(Last 20 bytes would be the Ethereum address)\n\n";

    // Test 4: Function signature
    std::string functionSig = "transfer(address,uint256)";
    auto hash4 = keccak256(functionSig);

    std::cout << "Function Signature: \"" << functionSig << "\"\n";
    std::cout << "Keccak256: " << to_hex(hash4) << "\n";
    std::cout << "Function Selector: 0x";

    for (int i = 0; i < 4; i++) {
        std::cout << std::hex << std::setw(2) << std::setfill('0') << (int)hash4[i];
    }
    std::cout << "\n\n";

    std::cout << "✓ Keccak-256 hashing complete!\n";

    return 0;
}
