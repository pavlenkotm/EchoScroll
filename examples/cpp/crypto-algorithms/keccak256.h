#ifndef KECCAK256_H
#define KECCAK256_H

#include <vector>
#include <string>
#include <sstream>
#include <cstdint>

namespace crypto {

// Compute Keccak-256 hash of data
std::vector<uint8_t> keccak256(const std::vector<uint8_t>& data);

// Compute Keccak-256 hash of string
std::vector<uint8_t> keccak256(const std::string& str);

// Convert bytes to hex string
std::string to_hex(const std::vector<uint8_t>& data);

} // namespace crypto

#endif // KECCAK256_H
