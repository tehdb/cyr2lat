_fs = require('fs')
_colors = require('colors')


class CyrToLat

	constructor : ->
		@error = false
		@ext = null
		@dir = null
		@files = []
		@logs = {
			dirs : 0
			files : 0
			rdirs : 0
			rfiles : 0
		}
		args = {
			dir : process.argv[2]
			ext : process.argv[3]
			run : process.argv[4]
		}

		if @checkArgs( args )
			if @scanDir( @dir )
				@renameFiles( @files )

				console.log( "********************************************************************************".green )
				console.log( @logs.dirs + " subdirecotries scanned, " + @logs.files + " files scanned" )
				console.log( @logs.rdirs + " subdirecotries renamed, " + @logs.rfiles + " files renamed" )
				console.log( "********************************************************************************".green )

		# prevent display error on unit tests
		else if @dir isnt "--coffee"
				console.log( "********************************************************************************".red )
				console.log( "ERROR\t".red + @error )
				console.log( "********************************************************************************".red )


	checkArgs : ( args ) ->
		if args.dir is undefined
			@error = "usage: coffee cyr2lat.coffee PATH-TO-DIR [EXTENSION]"
			return false
		else
			@dir = args.dir


		# check if dir is dir
		if not _fs.existsSync( @dir ) or not _fs.statSync(@dir).isDirectory()
			@error =  @dir + " not exists or is not a directory"
			return false

		#cut off trailing slash
		@dir = @dir.substr(0, (@dir.length - 1) ) if @dir.substr(-1) is "/"
		@ext = args.ext.toLowerCase() if args.ext?
		@error = false

		return true


	scanDir : ( dir, type ) ->
		files = _fs.readdirSync( dir )
		for f,i in files
			continue if not files.hasOwnProperty(i) or f is ".DS_Store"


			fname = dir + "/" + f
			fstats = _fs.statSync( fname )

			file = {
				name : fname
				lname : @mapToLatin( fname )
				stats : fstats
				type : if fstats.isDirectory() then "dir" else "file"
			}

			@files.push( file )
			if file.stats.isDirectory()
				@logs.dirs++
				@scanDir( file.name, "subdir")
			else
				@logs.files++

		return true if not type?


	renameFiles : (files) ->
		for f,i in files
			@renameFile( f )


	renameFile : (file) ->
		# do not rename files with no special chars
		return false if file.name is file.lname

		# exclude files which not match extension if given
		return false if @ext? and file.type is "file" and @ext isnt @getExt( file.name )

		if _fs.existsSync( file.lname )
			file.lname = @getIncFilename( file.lname, file.type )
			@renameFile( file )
		else
			_fs.renameSync( file.name, file.lname )
			if file.type is 'dir'
				@logs.rdirs++
			else
				@logs.rfiles++


	getExt : (filename) ->
		i = filename.lastIndexOf('.')
		res = if i < 0 then '' else filename.substr(i+1).toLowerCase()


	mapToLatin : (string) ->
		cyrMap = {
			'А': 'A'
			'а': 'a'
			'Б': 'B'
			'б': 'b'
			'В': 'V'
			'в': 'v'
			'Г': 'G'
			'г': 'g'
			'Д': 'D'
			'д': 'd'
			'Е': 'E'
			'е': 'e'
			'Ё': 'Jo'
			'ё': 'jo'
			'Ж': 'Zh'
			'ж': 'zh'
			'З': 'Z'
			'з': 'z'
			'И': 'I'
			'и': 'i'
			'Й': 'J'
			'й': 'j'
			'К': 'K'
			'к': 'k'
			'Л': 'L'
			'л': 'l'
			'М': 'M'
			'м': 'm'
			'Н': 'N'
			'н': 'n'
			'О': 'O'
			'о': 'o'
			'П': 'P'
			'п': 'p'
			'Р': 'R'
			'р': 'r'
			'С': 'S'
			'с': 's'
			'Т': 'T'
			'т': 't'
			'У': 'U'
			'у': 'u'
			'Ф': 'F'
			'ф': 'f'
			'Х': 'H'
			'х': 'h'
			'Ц': 'C'
			'ц': 'c'
			'Ч': 'Ch'
			'ч': 'ch'
			'Ш': 'Sh'
			'ш': 'sh'
			'Щ': 'Ssh'
			'щ': 'ssh'
			'Ъ': '#'
			'ъ': '#'
			'Ы': 'Y'
			'ы': 'y'
			'Ь': '"'
			'ь': '\''
			'Э': 'Je'
			'э': 'je'
			'Ю': 'Ju'
			'ю': 'ju'
			'Я': 'Ja'
			'я': 'ja'
		}

		specialCharsMap = {
			'№' : 'Nr'
		}

		res = string.split('').map( (char) ->
			cyrMap[char] || char
		).join("")

		res = res.split('').map( (char) ->
			specialCharsMap[char] || char
		).join("")



		res = res.replace(/[̆̈«»]/g, '')
		return res


	getIncFilename : ( path, type ) ->
		spath = path
		ext = null
		first = true

		if type is 'file'
			dotIdx = path.lastIndexOf('.')
			spath = path.substr('0', dotIdx )
			ext = path.substr(dotIdx)

		# check count
		openBrIdx = spath.lastIndexOf('(')
		closeBrIdx = spath.lastIndexOf(')')


		if openBrIdx isnt -1 and closeBrIdx is (spath.length - 1)
			count = parseInt( spath.substring( (openBrIdx+1), closeBrIdx ), 10)

			if typeof count is 'number' and count > 0
				count++
				path = path.substr(0, (openBrIdx+1) ) + count + ")"
				path += ext if ext isnt null
				first = false

		if first
			if ext isnt null
				path = path.substr(0, path.lastIndexOf('.')) + '(1)' + ext
			else
				path += '(1)'

		return path



exports.CyrToLat = CyrToLat

new CyrToLat

