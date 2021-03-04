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
# DimensionFun
对数组按维度执行函数，支持单一维度隐式扩展和返回数组自动拼接

对数组进行批处理是十分常用的操作。但是arrayfun和cellfun只能进行按元素运算，不能按行、按列甚至按平面运算，而且不支持单一维度隐式扩展，如果返回值不是标量还不能自动拼接。采用本函数可以实现按任意维度运算，且支持单一维度隐式扩展，返回数组自动拼接。
```MATLAB
%% 图像拼接-1
%本示例将一系列宽度相同的图片纵向拼接成一张长图。假设ImagePaths是一个包含了待拼接图像路径的列向量
imshow(DimensionFun(@imread,"Linear",ImagePaths,"SplitDimensions",1));
%由于ImagePaths是向量，且imread返回uint8数值类型，因此以下写法也是等效的：
imshow(DimensionFun(@imread,"EsNlcs",ImagePaths,"PackDimensions",2));
%% 图像拼接-2
%同样是拼接图象，如果ImagePaths是一个待拼接的子图路径的矩阵呢？同样可以按照这个矩阵对这些图像自动进行二维拼接！
imshow(DimensionFun(@imread,"EsNlcs",ImagePaths,"SplitDimensions",[1 2]));
%% 序列采样-拆分打包与隐式扩展的相互作用展示
Sequence=1:10;
Start=(1:5)';
End=(6:10)';
disp(DimensionFun(@(Sequence,Start,End)Sequence(Start:End),"Linear",Sequence,Start,End,"SplitDimensions",1));
%输出
%     1     2     3     4     5     6
%     2     3     4     5     6     7
%     3     4     5     6     7     8
%     4     5     6     7     8     9
%     5     6     7     8     9    10
%注意，由于SplitDimensions仅为第1维，因此具有单一第1维的Sequence发生了隐式扩展，而具有单一第2维的Start和End未发生隐式扩展，而是直接打包交付给Function运算。
```
请注意，CatMode参数默认值为DontCat，即将每次调用Function产生的返回值放在单独的元胞中，这种处理方式具有最高的健壮性，不容易出错，但性能较低。如果这些返回值均为相同类型的标量，希望返回数组，应将CatMode设为Scalar。其它可选CatMode值的含义见下文。
## 位置参数
Function(1,1)function_handle，必需，要执行的函数。必须接受等同于Arguments重复次数的参数

CatMode(1,1)string，可选，默认DontCat，根据其它参数的具体情况设定，必须为以下四者之一：
- Scalar，Function的返回值为标量。
- Linear，SplitDimensions为标量，且Function的返回值为类型、PackDimensions维度上尺寸均相同的数组
- EsNlcs，Function的返回值为数值、逻辑、字符或字段相同的结构体数组，且尺寸完全相同
- DontCat，不符合上述任何条件，或返回值为函数句柄

无论何种情况，都可以设为DontCat；其它选项都必须满足特定条件（对Function的每个返回值）。此外若Function的任何一个返回值是函数句柄，都只能选择DontCat。
## 重复参数
Arguments，输入参数数组。输入的数组个数必须等于Function所能接受的输入值个数。所有数组各维度尺寸要么相等，要么为1，不允许各不相同的维度尺寸。
## 名称-值对组参数
以下两个名称-值对组参数只能选择其中一个进行指定，另一个将会自动计算得出

PackDimensions(1,:)uint8{mustBePositive}，将每个Arguments数组的指定维度打包，在其它维度（即SplitDimensions）上拆分，分别交付给Function执行

SplitDimensions(1,:)uint8{mustBePositive}，在每个Arguments数组的指定维度上拆分，将其它维度（即PackDimensions）打包，分别交付给Function执行

注意，拆分-打包步骤在隐式扩展之前。也就是说，由于PackDimensions指定的维度被包入了同一个元胞当中，尺寸恒为1，即使不同数组间这些维度具有不同的尺寸，也不会进行隐式扩展。隐式扩展仅在SplitDimensions中进行。

如果两个参数都不指定，将把第一个Arguments所有非单一维度视为SplitDimensions，其它维度作为PackDimensions
## 返回值
返回值为由Function的返回值按其所对应的参数在数组中的位置拼接成的数组。如果Function具有多个返回值，则每个返回值各自拼接成数组，作为本函数的多个返回值。根据CatMode不同：
- Scalar，返回数组，尺寸与每个Arguments隐式扩展后的尺寸相同
- Linear & EsNlcs，返回数组，该数组由返回值在SplitDimensions维度上的拼接得到
- DontCat，返回元胞数组，尺寸与每个Arguments隐式扩展后的尺寸相同，元胞里是对应位置的Arguments输入Function产生的返回值
## 已知问题
当Arguments里含有表格时，将产生未知行为。
# FolderFun
取对一个文件夹下所有满足给定文件名模式的文件的绝对路径，对它们执行函数
## 必需参数
Function(1,1)function_handle，要执行的函数句柄。必须接受1个文件路径作为输入参数。

Directory(1,1)string，要遍历的文件夹路径
## 可选参数
Filename(1,1)string="*"，要筛选出的文件名模式，默认所有文件
## 名称-值对组参数
UniformOutput(1,1)logical=true，是否将输出值直接拼接成向量。若false，则将每个输出值套上一层元胞以后再拼接成向量。如果Function返回的不是标量，必须设为false。
## 返回值
每个文件路径执行函数后的返回值向量。如果Function有多个返回值，则返回同样多个向量，每个向量元素对应位置都是对一个文件调用Function产生的返回值。根据UniformOutput的设定，这些元素有可能还会套在一层元胞里。
# OpenFileDialog
可以设置初始目录，以及保存上次所在目录的文件打开对话框

MATLAB自带的uigetfile只能将初始目录设为当前目录，且下次打开时不能自动恢复到上次打开的目录，十分不便。本函数调用System.Windows.Forms.OpenFileDialog解决了这一问题。
## 名称-值对组参数
### Filter
(1,1)string，文件名筛选器。

对于每个筛选选项，筛选器字符串都包含筛选器的说明，后跟竖线和筛选器模式。 不同筛选选项的字符串用竖线分隔。

下面是筛选器字符串的示例：
```
Text files (*.txt)|*.txt|All files (*.*)|*.*
```
可以通过用分号分隔文件类型将多个筛选模式添加到筛选器，例如：
```
Image Files(*.BMP;*.JPG;*.GIF)|*.BMP;*.JPG;*.GIF|All files (*.*)|*.*
```
### InitialDirectory
(1,1)string，文件对话框中显示的初始目录
### Multiselect
(1,1)logical。如果对话框允许同时选定多个文件，则为 true；反之，则为 false。 默认值为 false。
### Title
(1,1)string，文件对话框标题。该字符串放置在对话框的标题栏中。 如果标题为空字符串，则系统将使用默认标题，即 "另存为" 或 "打开"。
## 返回值
FilePaths(:,1)string，包含对话框中所有选定文件的文件名。每个文件名同时包含文件路径和扩展名。如果未选择任何文件，则返回一个空数组。