<-- 引入 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.css">
  <script src="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.min.js"></script>

<-- 添加一个容器-->
<div id="gitalk-container"></div>

<-- 生成 gitalk 插件-->
var gitalk = new Gitalk({
  clientID: '56f73fbc5e79a466ea62', //Client ID

  clientSecret: '26d8eb4f3b0de9ce02382103ffc32ba34c4671f4', //Client Secret

  repo: 'blogtalk',//仓库名称
  owner: 'smfx1314',//仓库拥有者
  admin: ['smfx1314'],
  id: location.href,      // Ensure uniqueness and length less than 50
  distractionFreeMode: false  // Facebook-like distraction free mode
})

gitalk.render('gitalk-container')