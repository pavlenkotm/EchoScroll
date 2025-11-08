/**
 * C Implementation of Keccak-256 Hash
 * Used in Ethereum for address generation and data hashing
 * Low-level cryptographic primitive implementation
 */

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define KECCAK_ROUNDS 24
#define RATE 136  // r = 1088 bits = 136 bytes for Keccak-256
#define CAPACITY 64  // c = 512 bits = 64 bytes

// Keccak round constants
static const uint64_t RC[KECCAK_ROUNDS] = {
    0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808aULL,
    0x8000000080008000ULL, 0x000000000000808bULL, 0x0000000080000001ULL,
    0x8000000080008081ULL, 0x8000000000008009ULL, 0x000000000000008aULL,
    0x0000000000000088ULL, 0x0000000080008009ULL, 0x000000008000000aULL,
    0x000000008000808bULL, 0x800000000000008bULL, 0x8000000000008089ULL,
    0x8000000000008003ULL, 0x8000000000008002ULL, 0x8000000000000080ULL,
    0x000000000000800aULL, 0x800000008000000aULL, 0x8000000080008081ULL,
    0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
};

// Rotation offsets
static const int ROTATION_OFFSETS[25] = {
    0,  1,  62, 28, 27,
    36, 44, 6,  55, 20,
    3,  10, 43, 25, 39,
    41, 45, 15, 21, 8,
    18, 2,  61, 56, 14
};

// State structure (1600 bits = 200 bytes)
typedef struct {
    uint64_t state[25];
} keccak_state;

// Rotate left
static uint64_t rotl64(uint64_t x, int n) {
    return (x << n) | (x >> (64 - n));
}

// Keccak-f[1600] permutation
static void keccak_f1600(uint64_t state[25]) {
    uint64_t C[5], D[5], B[25];

    for (int round = 0; round < KECCAK_ROUNDS; round++) {
        // Theta step
        for (int x = 0; x < 5; x++) {
            C[x] = state[x] ^ state[x + 5] ^ state[x + 10] ^ state[x + 15] ^ state[x + 20];
        }

        for (int x = 0; x < 5; x++) {
            D[x] = C[(x + 4) % 5] ^ rotl64(C[(x + 1) % 5], 1);
        }

        for (int x = 0; x < 5; x++) {
            for (int y = 0; y < 5; y++) {
                state[x + 5 * y] ^= D[x];
            }
        }

        // Rho and Pi steps
        for (int x = 0; x < 5; x++) {
            for (int y = 0; y < 5; y++) {
                B[y + 5 * ((2 * x + 3 * y) % 5)] = rotl64(
                    state[x + 5 * y],
                    ROTATION_OFFSETS[x + 5 * y]
                );
            }
        }

        // Chi step
        for (int x = 0; x < 5; x++) {
            for (int y = 0; y < 5; y++) {
                state[x + 5 * y] = B[x + 5 * y] ^
                    ((~B[(x + 1) % 5 + 5 * y]) & B[(x + 2) % 5 + 5 * y]);
            }
        }

        // Iota step
        state[0] ^= RC[round];
    }
}

// Initialize Keccak state
void keccak_init(keccak_state *ctx) {
    memset(ctx->state, 0, sizeof(ctx->state));
}

// Absorb data into Keccak state
void keccak_absorb(keccak_state *ctx, const uint8_t *input, size_t len) {
    uint8_t *state_bytes = (uint8_t *)ctx->state;

    while (len >= RATE) {
        for (size_t i = 0; i < RATE; i++) {
            state_bytes[i] ^= input[i];
        }
        keccak_f1600(ctx->state);
        input += RATE;
        len -= RATE;
    }

    // Absorb remaining bytes
    for (size_t i = 0; i < len; i++) {
        state_bytes[i] ^= input[i];
    }
}

// Finalize and squeeze output
void keccak_finalize(keccak_state *ctx, uint8_t *output, size_t outlen) {
    uint8_t *state_bytes = (uint8_t *)ctx->state;

    // Padding: 0x01 || 0x00...00 || 0x80
    state_bytes[RATE - 1] ^= 0x80;
    state_bytes[0] ^= 0x01;

    keccak_f1600(ctx->state);

    // Extract output
    memcpy(output, state_bytes, outlen);
}

// Complete Keccak-256 hash
void keccak256(const uint8_t *input, size_t len, uint8_t output[32]) {
    keccak_state ctx;
    keccak_init(&ctx);
    keccak_absorb(&ctx, input, len);
    keccak_finalize(&ctx, output, 32);
}

// Convert bytes to hex string
void bytes_to_hex(const uint8_t *bytes, size_t len, char *hex) {
    for (size_t i = 0; i < len; i++) {
        sprintf(hex + i * 2, "%02x", bytes[i]);
    }
}

// Example: Ethereum address generation
void generate_eth_address(const uint8_t *public_key, uint8_t address[20]) {
    uint8_t hash[32];
    keccak256(public_key, 64, hash);  // Hash uncompressed public key (64 bytes)
    memcpy(address, hash + 12, 20);   // Take last 20 bytes
}

int main() {
    // Test Keccak-256
    const char *test_input = "Hello, Ethereum!";
    uint8_t hash[32];
    char hex[65] = {0};

    keccak256((uint8_t *)test_input, strlen(test_input), hash);
    bytes_to_hex(hash, 32, hex);

    printf("Input: %s\n", test_input);
    printf("Keccak-256: 0x%s\n", hex);

    // Test empty string (should match Ethereum's keccak256(''))
    const char *empty = "";
    keccak256((uint8_t *)empty, 0, hash);
    bytes_to_hex(hash, 32, hex);
    printf("\nKeccak-256(''): 0x%s\n", hex);

    return 0;
}
