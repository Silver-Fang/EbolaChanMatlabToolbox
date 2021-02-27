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
# ColorAllocate
为白色背景下的作图分配合适的颜色

作图时不知道使用什么颜色最显眼、最有区分度？本函数生成白色背景下的最优化配色方案。如果背景是黑色，用255减去分配出的颜色即可。

本函数会自动保存以前的计算结果，可以重复利用加快计算。
```MATLAB
Data=rand(9,9);
tic;
Colors=ColorAllocate(9)
toc
figure;
hold on;
for a=1:9
	plot(Data(a,:),"Color",Colors(a,:));
end
%再次调用速度加快，因为保存了之前的结果
tic;
Colors=ColorAllocate(9)
toc
```
## 输入参数
NoColors(1,1)uint8，必需参数，要分配的颜色个数

TryCount(1,1)uint8=0，可选位置参数，尝试优化的次数。一般来说次数越多优化效果越好，但更消耗时间。默认如果找到了保存的计算结果就不再尝试优化，否则优化1次。
## 返回值
Colors(:,3)，每一行代表一个颜色的RGB值