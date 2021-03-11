function varargout = DFSuperCat(varargout,CatMode,SplitDimensions)
switch CatMode
	case "EsNlcs"
		varargout=cellfun(@cell2mat,varargout,"UniformOutput",false);
	case "Linear"
		varargout=cellfun(@(Out)cat(SplitDimensions,Out{:}),varargout,"UniformOutput",false);
	case "CanCat"
		varargout=cellfun(@SuperCell2Mat,varargout,"UniformOutput",false);
end
end