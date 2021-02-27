埃博拉酱的MATLAB工具包，包含简单的单文件MATLAB函数
# ParseRepeatingFlagArguments
分析旗帜类重复参数到逻辑变量
```MATLAB
function TiffBatchRegister(Flags)
arguments(Repeating)
	Flags(1,1)string{mustBeMember(Flags,["Silent","Sequential"])}
end
[Silent,Sequential]=ParseRepeatingFlagArguments(Flags,"Silent","Sequential");
%得到这两个旗帜是否被调用方指定的逻辑值
```
## 必需参数
InputFlags(1,:)cell，调用方传来的，待分析的旗帜类重复参数
## 重复参数
ValidFlags(1,1)string，函数规定的有效旗帜
## 返回值
varargout(1,1)logical，数目与ValidFlags重复次数相同，返回每个有效旗帜是否存在（被调用方指定）的逻辑值