--[[
	Credit: [GOTR]Mechwarrior001
]]

local function CheckExt(File, Prc, Exts)
	if ((not istable(Exts)) or tobool(Exts[string.GetExtensionFromFilename(File)])) then
		Prc(File)
	end
end

local function ProcDirs(Dir, Prc, Path)
	local Files, Dirs = file.Find(Dir.."/*", Path)

	if (istable(Files) and (#Files > 0)) then
		for _, File in ipairs(Files) do
			CheckExt(Dir.."/"..File, Prc, Exts)
		end
	end

	if (istable(Dirs) and (#Dirs > 0)) then
		table.RemoveByValue(Dirs, "/")

		for _, Subdir in ipairs(Dirs) do
			ProcDirs(Dir.."/"..Subdir, Prc, Path)
		end
	end
end

--[[
	ProcDirTree

	Process Directory Tree
	Finds all files in a directory tree and passes their file path as an argument to the specified function

	string Dir		- Directory to parse
	string Path		- Engine mount path
	function Prc	- Function to pass filepaths to
	table Exts		- Optional table containing a whitelist of file extensions to process; Syntax is in the form of: { ["ext"] = true, }
--]]
function ProcDirTree(Dir, Path, Prc, Exts)

	local Files, Dirs = file.Find(Dir.."/*", Path)
	table.RemoveByValue(Dirs, "/")

	for _, File in ipairs(Files) do
		CheckExt(Dir.."/"..File, Prc, Exts)
	end

	for _, Dir2 in ipairs(Dirs) do
		ProcDirs(Dir.."/"..Dir2, Prc, Path)
	end
end
