CyrToLat = require("../cyr2lat").CyrToLat

describe "cyr2lat testing", ->

	ctl = null

	beforeEach ->
		ctl = new CyrToLat

	it "should map cyrillic to latin", (done) ->
		expect( ctl.mapToLatin( "файл") ).toEqual "fajl"
		expect( ctl.mapToLatin( "file") ).toEqual "file"

		done()

	it "should return file extension", (done) ->
		expect( ctl.getExt( "file.txt") ).toEqual "txt"
		expect( ctl.getExt( "file.1.txt") ).toEqual "txt"
		expect( ctl.getExt( "файл.txt") ).toEqual "txt"

		done()

	it "should increment count for directories", (done) ->
		expect( ctl.getIncFilename( "dirname", "dir") ).toEqual "dirname(1)"
		expect( ctl.getIncFilename( "dirname/subdir", "dir") ).toEqual "dirname/subdir(1)"
		expect( ctl.getIncFilename( "dirname(2)", "dir") ).toEqual "dirname(3)"
		expect( ctl.getIncFilename( "dirna(me)", "dir") ).toEqual "dirna(me)(1)"
		expect( ctl.getIncFilename( "dir(na)me", "dir") ).toEqual "dir(na)me(1)"
		expect( ctl.getIncFilename( "(dir)name", "dir") ).toEqual "(dir)name(1)"

		done()

	it "should increment count for files", (done) ->
		expect( ctl.getIncFilename( "filename.txt", "file") ).toEqual "filename(1).txt"
		expect( ctl.getIncFilename( "dir/filename.txt", "file") ).toEqual "dir/filename(1).txt"
		expect( ctl.getIncFilename( "filename(1).txt", "file") ).toEqual "filename(2).txt"
		expect( ctl.getIncFilename( "filena(me).txt", "file") ).toEqual "filena(me)(1).txt"
		expect( ctl.getIncFilename( "file(na)me.txt", "file") ).toEqual "file(na)me(1).txt"
		expect( ctl.getIncFilename( "(fi)lename.txt", "file") ).toEqual "(fi)lename(1).txt"
		expect( ctl.getIncFilename( "file(1)name.txt", "file") ).toEqual "file(1)name(1).txt"
		expect( ctl.getIncFilename( "(1)filename.txt", "file") ).toEqual "(1)filename(1).txt"

		done()

	it "should check if dir is passed thru command line arguments", (done) ->
		args = {}
		expect( ctl.checkArgs(args) ).toBeFalsy()
		expect( ctl.error ).not.toBeFalsy()

		done()


	it "should check if dir exists and cut off trailing slash", (done) ->
		args1 = { 'dir' : "testdir/" }
		args2 = { 'dir' : "dir-not-exists"}

		expect( ctl.checkArgs(args1) ).toBeTruthy()
		expect( ctl.error ).toBeFalsy()
		expect( ctl.dir ).toEqual "testdir"

		expect( ctl.checkArgs(args2) ).toBeFalsy()
		expect( ctl.error ).not.toBeFalsy()

		done()

	it "should store extension passed thro command line arguments", (done) ->
		args = {
			'dir' : "testdir"
			'ext' : "txt"
		}

		ctl.checkArgs( args )
		expect( ctl.ext ).toEqual "txt"

		done()

	it "should not rename files with no special chars", (done) ->
		filename = "test.txt"
		file = {
			name : filename
			lname : ctl.mapToLatin( filename )
		}
		expect( ctl.renameFile( file ) ).toBeFalsy()
		done()

	it "should only rename files with given excensions", (done) ->
		args = {
			'dir' : "testdir"
			'ext' : "doc"
		}

		file = {
			name : "testfile.txt"
			type : "file"
		}

		ctl.checkArgs( args )
		expect( ctl.ext ).toEqual "doc"
		expect( ctl.getExt(file.name) ).toEqual "txt"
		expect( ctl.renameFile(file) ).toBeFalsy()

		done()

