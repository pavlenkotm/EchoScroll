<script lang="ts">
  // Svelte Web3 DApp
  // Reactive UI for Ethereum

  import { onMount } from 'svelte';
  import { ethers } from 'ethers';

  let provider: ethers.BrowserProvider | null = null;
  let signer: ethers.JsonRpcSigner | null = null;
  let account: string = '';
  let balance: string = '0';
  let chainId: number = 0;
  let connected: boolean = false;

  async function connectWallet() {
    if (typeof window.ethereum !== 'undefined') {
      try {
        provider = new ethers.BrowserProvider(window.ethereum);
        await provider.send('eth_requestAccounts', []);
        signer = await provider.getSigner();
        account = await signer.getAddress();

        const balanceWei = await provider.getBalance(account);
        balance = ethers.formatEther(balanceWei);

        const network = await provider.getNetwork();
        chainId = Number(network.chainId);

        connected = true;
      } catch (error) {
        console.error('Connection error:', error);
        alert('Failed to connect wallet');
      }
    } else {
      alert('Please install MetaMask!');
    }
  }

  async function sendTransaction(to: string, amount: string) {
    if (!signer) return;

    try {
      const tx = await signer.sendTransaction({
        to: to,
        value: ethers.parseEther(amount)
      });

      await tx.wait();
      alert(`Transaction sent: ${tx.hash}`);

      // Refresh balance
      const balanceWei = await provider!.getBalance(account);
      balance = ethers.formatEther(balanceWei);
    } catch (error) {
      console.error('Transaction error:', error);
      alert('Transaction failed');
    }
  }

  async function switchNetwork(targetChainId: number) {
    try {
      await window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{ chainId: `0x${targetChainId.toString(16)}` }],
      });
    } catch (error) {
      console.error('Network switch error:', error);
    }
  }

  onMount(() => {
    if (window.ethereum) {
      window.ethereum.on('accountsChanged', (accounts: string[]) => {
        if (accounts.length === 0) {
          connected = false;
          account = '';
          balance = '0';
        } else {
          account = accounts[0];
          connectWallet();
        }
      });

      window.ethereum.on('chainChanged', () => {
        window.location.reload();
      });
    }
  });
</script>

<main class="container">
  <h1>🦊 Svelte Web3 Wallet</h1>

  {#if !connected}
    <button on:click={connectWallet} class="connect-btn">
      Connect Wallet
    </button>
  {:else}
    <div class="wallet-info">
      <h2>Connected</h2>
      <p><strong>Account:</strong> {account.slice(0, 6)}...{account.slice(-4)}</p>
      <p><strong>Balance:</strong> {Number(balance).toFixed(4)} ETH</p>
      <p><strong>Chain ID:</strong> {chainId}</p>
    </div>

    <div class="actions">
      <h3>Send Transaction</h3>
      <form on:submit|preventDefault={() => sendTransaction('0x...', '0.01')}>
        <input type="text" placeholder="Recipient address" />
        <input type="number" placeholder="Amount (ETH)" step="0.01" />
        <button type="submit">Send</button>
      </form>
    </div>

    <div class="networks">
      <button on:click={() => switchNetwork(1)}>Ethereum</button>
      <button on:click={() => switchNetwork(137)}>Polygon</button>
      <button on:click={() => switchNetwork(42161)}>Arbitrum</button>
    </div>
  {/if}
</main>

<style>
  .container {
    max-width: 600px;
    margin: 2rem auto;
    padding: 2rem;
    background: #1a1a1a;
    border-radius: 12px;
    color: white;
  }

  h1 {
    text-align: center;
    margin-bottom: 2rem;
  }

  .connect-btn {
    display: block;
    width: 100%;
    padding: 1rem;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    border-radius: 8px;
    color: white;
    font-size: 1.2rem;
    cursor: pointer;
    transition: transform 0.2s;
  }

  .connect-btn:hover {
    transform: translateY(-2px);
  }

  .wallet-info {
    background: #2a2a2a;
    padding: 1.5rem;
    border-radius: 8px;
    margin-bottom: 1.5rem;
  }

  .actions form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  input, button {
    padding: 0.75rem;
    border-radius: 6px;
    border: 1px solid #444;
    background: #2a2a2a;
    color: white;
  }

  .networks {
    display: flex;
    gap: 0.5rem;
    margin-top: 1rem;
  }

  .networks button {
    flex: 1;
    padding: 0.5rem;
    background: #2a2a2a;
    cursor: pointer;
  }
</style>
