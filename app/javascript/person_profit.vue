<template>
  <div id="app">
    <button >商材ステータス</button>
    <button>決済一覧</button>
    <button>不備一覧</button>
    <p>{{ message }}</p>
    <p>{{ users.length }}</p>
    <my-component></my-component>
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