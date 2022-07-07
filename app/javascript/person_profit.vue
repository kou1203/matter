<template>
  <div id="app">
    <p>{{ message }}</p>
    <p>{{ users.length }}</p>
  </div>
</template>


<script>
export default {
  data: function () {
    return {
      message: "Hello Vue world!",
      users: users
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
  color:red;
}
</style>