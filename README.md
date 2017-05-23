因为kubectl有些难用，所以有了如下脚本。和kubectl的区别主要在于命令后置。比如k
`kubed get pod 2 show=kubectl describe pod *2*`注意这里的关键词2是可以进行模糊匹配的。

与之相近的还有`kubed get pod 2 delete=kubectl delete pod *2*`,还有一个deleteall`kubed get pod running deleteall`这样可以杀掉所有`running`状态的pod。这里的关键词为kubectl get pod得到的所有内容，包括pod名字，运行状态等。如果不清楚请慎用。

`kubed convert all`可以将当前目录下的所有.yaml都create -f。

更多有趣的功能还将慢慢添加
