function varargout = DFSuperCat(varargout,CatMode,SplitDimensions)
switch CatMode
	case "EsNlcs"
		varargout=cellfun(@cell2mat,varargout,"UniformOutput",false);
	case "Linear"
		varargout=cellfun(@(Out)cat(SplitDimensions,Out{:}),varargout,"UniformOutput",false);
	case "CanCat"
		varargout=cellfun(@SuperCell2Mat,varargout,"UniformOutput",false);
		NoSD=numel(SplitDimensions);
		for a=1:nargout
			Out=varargout{a};
			for b=1:NoSD-1
				SD=SplitDimensions(b);
				Out=cellfun(@(O)cat(SD,O{:}),num2cell(Out,SplitDimensions(b)),"UniformOutput",false);
			end
			varargout{a}=cat(SplitDimensions(end),Out{:});
		end
end
end