<template>
  <div class="fixed inset-0 flex items-center justify-center bg-overlay p-6" v-show="error">
    <ae-card class="bg-white">
      <div class="w-full">
        <h1 class="font-mono font-bold text-center text-black text-3xl pt-4 italic">Ooops!</h1>
        <p class="text-base pt-4 text-center">
          {{error}}
        </p>
        <div class="flex justify-center mt-6">
          <ae-button fill="primary" face="round" @click="ctaClick">{{errorCTA}}</ae-button>
        </div>
      </div>
    </ae-card>
  </div>
</template>

<script>
    import {AeButton, AeCard} from '@aeternity/aepp-components'

    export default {
        name: 'CriticalErrorOverlay',
        components: {AeButton, AeCard},
        props: {
            error: {
                type: String,
                default: null
            },
            errorCTA: {
                type: String,
                default: "Okay"
            }
        },
        methods: {
            ctaClick() {
                this.$emit('continue')
            }
        }
    }
</script>

<style scoped>
  .white-bg {
    background-color: white;
  }

  .bg-overlay {
    background-color: rgba(255, 255, 255, 0.95);
  }
</style>
