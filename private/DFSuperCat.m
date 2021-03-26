function varargout = DFSuperCat(varargout,CatMode,SplitDimensions)
switch CatMode
	case "EsNlcs"
		varargout=cellfun(@cell2mat,varargout,"UniformOutput",false);
	case "Linear"
		if isempty(SplitDimensions)
			%这里不能使用varargout=horzcat(varargout{:})，因为varargout元胞里有可能是空的
			varargout=cellfun(@(Out)vertcat(Out{:}),varargout,"UniformOutput",false);
		else
			varargout=cellfun(@(Out)cat(SplitDimensions,Out{:}),varargout,"UniformOutput",false);
		end
	case "CanCat"
		varargout=cellfun(@SuperCell2Mat,varargout,"UniformOutput",false);
end
end