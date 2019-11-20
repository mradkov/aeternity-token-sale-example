<template>
  <div>
    <div class="overlay-loader" v-show="showLoading && !error">
      <BiggerLoader></BiggerLoader>
    </div>
    <div class="p-2">
      <ae-identity class="bg-primary" v-bind="identity" collapsed/>
      <h1 class="h1">Sample Test Token Sale</h1>
      <div>This is a sample token sale on aeternity testnet, each token sells for
        <span v-if="price" class="font-bold">{{price}}</span>
        <ae-loader v-else/>
        <span class="font-bold">AEtto</span>.
        These tokens don't carry any value and should only function as example showcase on testnet.
      </div>

      <h1 class="h1">STT Balance:
        <span v-if="sttbalance !== null" class="font-bold">{{sttbalance}}</span>
        <ae-loader v-else/>
      </h1>

      <ae-input label="Amount of Tokens to Buy" type="number" min="0.1" v-model="buyAmount"/>
      <ae-button face="round" fill="primary" extend @click="contribute()">Buy {{buyAmount}} STT for {{buyAmount*price}}
        AEtto
      </ae-button>

      <div class="flex mt-3">
        <div class="w-1/4">
          <ae-input label="Amount" v-model="transferAmount"/>
        </div>
        <div class="w-3/4">
          <ae-input label="Address" v-model="transferAddress"/>
        </div>
      </div>
      <ae-button face="round" fill="primary" extend @click="send()">Send {{transferAmount}} STT</ae-button>
    </div>
    <CriticalErrorOverlay :error="error" @continue="$router.go()"></CriticalErrorOverlay>
  </div>
</template>

<script>
    import axios from "axios";
    import aeternity from "../utils/aeternity";
    import {AeIdentity, AeLoader, AeInput, AeButton, AeButtonGroup} from "@aeternity/aepp-components";
    import BiggerLoader from "../components/BiggerLoader";
    import CriticalErrorOverlay from "../components/CriticalErrorOverlay";

    export default {
        name: 'Home',
        components: {AeIdentity, AeLoader, AeInput, AeButton, AeButtonGroup, BiggerLoader, CriticalErrorOverlay},
        data() {
            return {
                error: null,
                showLoading: false,
                buyAmount: 1337,
                price: null,
                sttbalance: null,
                identity: null,
                transferAmount: 0,
                transferAddress: null
            };
        },
        methods: {
            async refresh() {
                this.identity = {
                    address: aeternity.address,
                    balance: parseInt(aeternity.balance)
                };
                this.sttbalance = (await aeternity.tokenContract.methods.balance(aeternity.address).catch(e => {
                    console.error(e);
                    this.error = "Contract Execution failed, please try again"
                })).decodedResult || 0;
                this.showLoading = false;
            },
            async contribute() {
                this.showLoading = true;
                await aeternity.saleContract.methods.contribute({amount: this.buyAmount * this.price}).catch(e => {
                    console.error(e);
                    this.error = "Contract Execution failed, please try again"
                });
                this.refresh();
            },
            async send() {
                this.showLoading = true;
                await aeternity.tokenContract.methods.transfer(this.transferAddress, this.transferAmount).catch(e => {
                    console.error(e);
                    this.error = "Contract Execution failed, please try again"
                });
                this.refresh();
            }
        },
        async mounted() {
            this.showLoading = true;
            await aeternity.initClient();

            if (aeternity.isTestnet() && aeternity.balance <= 5) {
                await axios.post(`https://testnet.faucet.aepps.com/account/${aeternity.address}`, {}, {headers: {'content-type': 'application/x-www-form-urlencoded'}}).catch(console.error);
            }

            if (!aeternity.isTestnet()) {
                this.error = "This Aepp is only available on Testnet, in Base-Aepp in Settings -> Network choose Testnet."
            }

            this.price = (await aeternity.saleContract.methods.price()).decodedResult;
            this.refresh();
        },
    };
</script>

<style scoped>

</style>
