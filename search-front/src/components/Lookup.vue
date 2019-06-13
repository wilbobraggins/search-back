<template>
  <div class="max-w-md m-auto py-10">
    <div class="text-red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl mb-4">Search For Something</h3>
    <form @submit.prevent="addLookup">
      <div class="mb-6">
        <input type="text"
          class="input"
          autofocus
          autocomplete="off"
          placeholder="Explore Stackoverflow"
          v-model="newLookup.search">
      </div>
      <input type="submit" value="Lookup" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-900 block w-full py-4 text-indigo-dark item-center justify-center"/>
    </form>

    <hr class="border border-gray-300 my-6">

    <ul class="list-reset mt-4">
      <li class="py-4" v-for="lookup in lookups" :key="lookup.id" :lookup="lookup">
      <div class="flex items-center justify-between flex-wrap">
          <p class="block flex-1 font-mono font-semibold flex items-center ">
            <svg class="fill-current text-indigo w-6 h-6 mr-2" viewBox="0 0 20 20" width="20" height="20"><title>searcher</title><path d="M15.75 8l-3.74-3.75a3.99 3.99 0 0 1 6.82-3.08A4 4 0 0 1 15.75 8zm-13.9 7.3l9.2-9.19 2.83 2.83-9.2 9.2-2.82-2.84zm-1.4 2.83l2.11-2.12 1.42 1.42-2.12 2.12-1.42-1.42zM10 15l2-2v7h-2v-5z"></path></svg>
            {{ lookup.search }}
          </p>

          <button class="bg-tranparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded"
          @click.prevent="editLookup(lookup)">Edit</button>

          <button class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
         @click.prevent="removeLookup(lookup)">Delete</button>
        </div>

        <div v-if="lookup == editedLookup">
          <form action="" @submit.prevent="updatelookup(lookup)">
            <div class="mb-6 p-4 bg-white rounded border border-grey-light mt-4">
              <input class="input" v-model="lookup.search" />
              <input type="submit" value="Update" class=" my-2 bg-transparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 rounded cursor-pointer">
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>

</template>

<script>
export default {
  name: 'Lookups',
  data () {
    return {
      lookups: [],
      newLookup: [],
      error: '',
      editedLookup: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/api/v1/lookups')
        .then(response => { this.lookups = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addLookup () {
      const value = this.newLookup
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/lookups/', { lookup: { search: this.newLookup.search } })
        .then(response => {
          this.lookups.push(response.data)
          this.newLookup = ''
        })
        .catch(error => this.setError(error, 'Cannot create search'))
    },
    removeLookup (lookup) {
      this.$http.secured.delete(`/api/v1/lookups/${lookup.id}`)
        .then(response => {
          this.lookups.splice(this.lookups.indexOf(lookup), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete search'))
    },
    editLookup (lookup) {
      this.editLookup = lookup
    },
    updateLookup (lookup) {
      this.editedLookup = ''
      this.$http.secured.patch(`/api/v1/lookups/${lookup.id}`, { lookup: { search: lookup.search } })
        .catch(error => this.setError(error, 'Cannot update Search'))
    }
  }
}
</script>
