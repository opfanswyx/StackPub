
# Stack Pub
Stack Pub(堆栈酒馆) 是计算机软件开发相关的NoteBook，主要包括后端开发与游戏开发方面相关知识。

本Blog受[OI Wiki](https://oi-wiki.org/) 的启发，基于[mkdocs-material](kit/mkdocs/)搭建，使用[Gitalk](https://gitalk.github.io/)评论系统，托管于[Github](https://github.com/opfanswyx/StackPub)平台。

---

#### Material color palette 颜色主题

> 默认主题为 `Indigo` 

点击色块可更换主题的主色

<div id="color-button">
<!--button data-md-color-primary="red">Red</button-->
<button data-md-color-primary="pink">Pink</button>
<!--button data-md-color-primary="purple">Purple</button-->
<button data-md-color-primary="deep-purple">Deep Purple</button>
<button data-md-color-primary="indigo">Indigo</button>
<button data-md-color-primary="blue">Blue</button>
<button data-md-color-primary="light-blue">Light Blue</button>
<button data-md-color-primary="cyan">Cyan</button>
<!--button data-md-color-primary="teal">Teal</button-->
<button data-md-color-primary="green">Green</button>
<!--button data-md-color-primary="light-green">LightGreen<button>
<button data-md-color-primary="lime">Lime</button-->
<!--button data-md-color-primary="yellow">Yellow</button>
<button data-md-color-primary="amber">Amber</button-->
<!--button data-md-color-primary="orange">Orange</button-->
<button data-md-color-primary="deep-orange">Deep Orange</button>
<!--button data-md-color-primary="brown">Brown</button-->
<button data-md-color-primary="white">White</button>
<!--button data-md-color-primary="grey">Grey</button-->
<button data-md-color-primary="blue-grey">Blue Grey</button>

</div>

<script>
  var buttons = document.querySelectorAll("button[data-md-color-primary]");
  Array.prototype.forEach.call(buttons, function(button) {
    button.addEventListener("click", function() {
      document.body.dataset.mdColorPrimary = this.dataset.mdColorPrimary;
      localStorage.setItem("data-md-color-primary",this.dataset.mdColorPrimary);
    })
  })
</script>
---


---   
!!! tip "blogroll"
    [radaren](http://leidar.ren/) (tm) 
    [StackHarbor](https://sh.alynx.moe/) (tm) 
    [iimt](http://www.iimt.me/) (tm)

??? quote "bye"
    我是我之所有因果之指向。(r)(tm)