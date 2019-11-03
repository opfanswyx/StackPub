## mkdocs-material部署
!!! note
    更多详细知识来自:[cyent(markdown)](https://cyent.github.io/markdown-with-mkdocs-material/syntax/main/)
### 安装
```python
pip install mkdocs mkdocs-material
```
### 初始化
```
mkdocs new project
```
### 本地服务启动
```
#在project目录下执行
mkdocs server
```
通过浏览器打开 http://127.0.0.1:8000/ 查看效果。
## 发布至GitHub Pages
github上新建项目，clone至本地，将mkdocs更目录(project)下的所有文件移动到git clone的本地目录里
```
mkdocs gh-deploy
```
## 发布至HTTP Server
```
mkdocs build
```
将site目录下所有东西同步至http server里。