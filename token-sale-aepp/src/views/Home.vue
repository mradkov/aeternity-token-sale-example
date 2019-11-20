<template>
  <div class="p-2">
    <ae-identity class="bg-primary" v-bind="identity" collapsed/>
    <h1 class="h1">Sample Token Sale (STT)</h1>
    <div>This is a sample token sale on aeternity testnet, each token sells for
      <span v-if="price" class="font-bold">{{price}}</span>
      <ae-loader v-else/>
      <span class="font-bold">AEtto</span>.
      These tokens don't carry any value and should only function as example showcase on testnet.
    </div>

    <h1 class="h1">STT Balance:
      <span v-if="sttbalance" class="font-bold">{{sttbalance}}</span>
      <ae-loader v-else/>
    </h1>

    <ae-input label="Amount of Tokens to Buy" v-model="amount"/>
    <ae-button face="round" fill="primary" extend @click="contribute()">Buy {{amount}} STT for {{amount/price}} AEtto</ae-button>
  </div>
</template>

<script>
    import aeternity from "../utils/aeternity";
    import {AeIdentity, AeLoader, AeInput, AeButton} from "@aeternity/aepp-components"

    export default {
        name: 'Home',
        components: {AeIdentity, AeLoader, AeInput, AeButton},
        data() {
            return {
                amount: 1,
                price: null,
                sttbalance: null,
                identity: null,
                aeternity: null
            };
        },
        methods: {
            async refresh() {
                await aeternity.initClient();

                if (aeternity.isTestnet() && aeternity.balance <= 5) {
                    await axios.post(`https://testnet.faucet.aepps.com/account/${aeternity.address}`, {}, {headers: {'content-type': 'application/x-www-form-urlencoded'}}).catch(console.error);
                }
                this.identity = {
                    address: aeternity.address,
                    balance: parseInt(aeternity.balance)
                };
                this.aeternity = aeternity;
                this.price = (await aeternity.saleContract.methods.price()).decodedResult;
                this.sttbalance = (await aeternity.tokenContract.methods.balance(aeternity.address)).decodedResult || 0;
            },
            async contribute() {
                await this.aeternity.saleContract.methods.contribute({amount: this.amount * this.price});
                this.refresh();
            }
        },
        async mounted() {
            this.refresh();
        },
    };
</script>

<style scoped>

</style>
