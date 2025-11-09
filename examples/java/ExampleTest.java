package com.web3.example;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.ECKeyPair;
import org.web3j.crypto.Keys;
import org.web3j.utils.Convert;

import java.math.BigDecimal;
import java.math.BigInteger;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for Web3 Java Example
 * Tests basic Web3j functionality
 */
public class ExampleTest {

    @Test
    public void testWeiToEtherConversion() {
        BigInteger weiValue = new BigInteger("1000000000000000000"); // 1 ETH in wei
        BigDecimal etherValue = Convert.fromWei(weiValue.toString(), Convert.Unit.ETHER);

        assertEquals(new BigDecimal("1"), etherValue);
    }

    @Test
    public void testEtherToWeiConversion() {
        BigDecimal etherValue = new BigDecimal("1");
        BigInteger weiValue = Convert.toWei(etherValue, Convert.Unit.ETHER).toBigInteger();

        assertEquals(new BigInteger("1000000000000000000"), weiValue);
    }

    @Test
    public void testGweiToWeiConversion() {
        BigDecimal gweiValue = new BigDecimal("50");
        BigInteger weiValue = Convert.toWei(gweiValue, Convert.Unit.GWEI).toBigInteger();

        assertEquals(new BigInteger("50000000000"), weiValue);
    }

    @Test
    public void testKeyPairGeneration() throws Exception {
        ECKeyPair keyPair = Keys.createEcKeyPair();

        assertNotNull(keyPair);
        assertNotNull(keyPair.getPrivateKey());
        assertNotNull(keyPair.getPublicKey());
    }

    @Test
    public void testCredentialsCreation() throws Exception {
        ECKeyPair keyPair = Keys.createEcKeyPair();
        Credentials credentials = Credentials.create(keyPair);

        assertNotNull(credentials);
        assertNotNull(credentials.getAddress());
        assertTrue(credentials.getAddress().startsWith("0x"));
        assertEquals(42, credentials.getAddress().length()); // 0x + 40 hex chars
    }

    @Test
    public void testAddressValidation() throws Exception {
        String validAddress = "0x742d35Cc6634C0532925a3b844Bc454e4438f44e";

        // Check address format
        assertTrue(validAddress.startsWith("0x"));
        assertEquals(42, validAddress.length());
        assertTrue(validAddress.matches("^0x[a-fA-F0-9]{40}$"));
    }

    @Test
    public void testBigIntegerArithmetic() {
        BigInteger value1 = new BigInteger("1000000000000000000"); // 1 ETH
        BigInteger value2 = new BigInteger("500000000000000000");  // 0.5 ETH

        BigInteger sum = value1.add(value2);
        BigInteger diff = value1.subtract(value2);

        assertEquals(new BigInteger("1500000000000000000"), sum);
        assertEquals(new BigInteger("500000000000000000"), diff);
    }
}
