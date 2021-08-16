function addToNewUrl() {
  let path = location.pathname;
  let pattern = /^.*\/new.*$/

  // URLが正しければ変更は不要
  if(path.match(pattern)) return;

  // URLを変更
  history.replaceState('', '', `${ path }/new`)
}
