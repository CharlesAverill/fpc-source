/*
 * Copyright (c) 2002, 2006, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Oracle designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Oracle in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */
/*
 * Portions Copyright (c) 2011 Jonas Maebe
 */


package fpc.tools.javapp;

import java.util.*;
import java.io.*;
import java.util.jar.*;


/**
 * Strores flag values according to command line options
 * and sets path where to find classes.
 *
 * @author  Sucheta Dambalkar
 */
public class JavapEnvironment {

    //Access flags
    public static final int PRIVATE = 0;
    public static final int PROTECTED  = 1;
    public static final int PACKAGE = 2;
    public static final int PUBLIC  = 3;

    //search path flags.
    private static final int start = 0;
    private static final int  cmdboot= 1;
    private static final int sunboot = 2;
    private static final int  javaclass= 3;
    private static final int  cmdextdir= 4;
    private static final int  javaext= 5;
    private static final int  cmdclasspath= 6;
    private static final int  envclasspath= 7;
    private static final int  javaclasspath= 8;
    private static final int  currentdir = 9;


    // JavapEnvironment flag settings
    boolean showLineAndLocal = false;
    int showAccess = PACKAGE;
    boolean showVerbose = false;
    String classPathString = null;
    String bootClassPathString = null;
    String extDirsString = null;
    boolean extDirflag;
    boolean nothingToDo = true;
    boolean showallAttr = false;
    boolean generateInclude = false;
    String classpath = null;
    String outputName = "java";
    ArrayList<String> excludePrefixes;
    ArrayList<String> skelPrefixes;

    public JavapEnvironment() {
    	excludePrefixes = new ArrayList<String>();
    	skelPrefixes = new ArrayList<String>();
    }
    
    /**
     *  According to which flags are set,
     *  returns file input stream for classfile to disassemble.
     */

    public InputStream getFileInputStream(String Name){
        InputStream fileInStream = null;
        int searchpath = cmdboot;
        extDirflag = false;
        try{
            if(searchpath == cmdboot){
                if(bootClassPathString != null){
                    //search in specified bootclasspath.
                    classpath = bootClassPathString;
                    if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                    //no classes found in search path.
                    else searchpath = cmdextdir;
                }
                else searchpath = sunboot;
            }

            if(searchpath == sunboot){
                if(System.getProperty("sun.boot.class.path") != null){
                    //search in sun.boot.class.path
                    classpath = System.getProperty("sun.boot.class.path");
                    if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                    //no classes found in search path
                    else searchpath = cmdextdir;
                }
                else searchpath = javaclass;
            }

            if(searchpath == javaclass){
                if(System.getProperty("java.class.path") != null){
                    //search in java.class.path
                    classpath =System.getProperty("java.class.path");
                    if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                    //no classes found in search path
                    else searchpath = cmdextdir;
                }
                else searchpath = cmdextdir;
            }

            if(searchpath == cmdextdir){
                if(extDirsString != null){
                    //search in specified extdir.
                    classpath = extDirsString;
                    extDirflag = true;
                    if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                    //no classes found in search path
                    else {
                        searchpath = cmdclasspath;
                        extDirflag = false;
                    }
                }
                else searchpath = javaext;
            }

            if(searchpath == javaext){
                if(System.getProperty("java.ext.dirs") != null){
                    //search in java.ext.dirs
                    classpath = System.getProperty("java.ext.dirs");
                    extDirflag = true;
                    if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                    //no classes found in search path
                    else {
                        searchpath = cmdclasspath;
                        extDirflag = false;
                    }
                }
                else searchpath = cmdclasspath;
            }
            if(searchpath == cmdclasspath){
                if(classPathString != null){
                    //search in specified classpath.
                    classpath = classPathString;
                    if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                    //no classes found in search path
                    else searchpath = 8;
                }
                else searchpath = envclasspath;
            }

            if(searchpath == envclasspath){
                if(System.getProperty("env.class.path")!= null){
                    //search in env.class.path
                    classpath = System.getProperty("env.class.path");
                    if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                    //no classes found in search path.
                    else searchpath = javaclasspath;
                }
                else searchpath = javaclasspath;
            }

            if(searchpath == javaclasspath){
                if(("application.home") == null){
                    //search in java.class.path
                    classpath = System.getProperty("java.class.path");
                    if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                    //no classes found in search path.
                    else searchpath = currentdir;
                }
                else searchpath = currentdir;
            }

            if(searchpath == currentdir){
                classpath = ".";
                //search in current dir.
                if((fileInStream = resolvefilename(Name)) != null) return fileInStream;
                else {
                    //no classes found in search path.
                    error("Could not find "+ Name);
                    System.exit(1);
                }
            }
        }catch(SecurityException excsec){
            excsec.printStackTrace();
            error("fatal exception");
        }catch(NullPointerException excnull){
            excnull.printStackTrace();
            error("fatal exception");
        }catch(IllegalArgumentException excill){
            excill.printStackTrace();
            error("fatal exception");
        }

        return null;
    }


    public void error(String msg) {
        System.err.println("ERROR:" +msg);
    }

    /**
     * Resolves file name for classfile to disassemble.
     */
    public InputStream resolvefilename(String name){
        String classname = name.replace('.', '/') + ".class";
        while (true) {
            InputStream instream = extDirflag
                ? resolveExdirFilename(classname)
                : resolveclasspath(classname);
            if (instream != null)
                return instream;
            int lastindex = classname.lastIndexOf('/');
            if (lastindex == -1) return null;
            classname = classname.substring(0, lastindex) + "$" +
                classname.substring(lastindex + 1);
        }
    }

    /**
     * Resolves file name for classfile to disassemble if flag exdir is set.
     */
    public InputStream resolveExdirFilename(String classname){
        if(classpath.indexOf(File.pathSeparator) != -1){
            //separates path
            StringTokenizer st = new StringTokenizer(classpath, File.pathSeparator);
            while(st.hasMoreTokens()){
                String path = st.nextToken();
                InputStream in = resolveExdirFilenamehelper(path, classname);
                if (in != null)
                    return in;
            }
        }else return (resolveExdirFilenamehelper(classpath, classname));

        return null;
    }

    /**
     * Resolves file name for classfile to disassemble.
     */
    public InputStream resolveclasspath(String classname){
        if(classpath.indexOf(File.pathSeparator) != -1){
            StringTokenizer st = new StringTokenizer(classpath, File.pathSeparator);
            //separates path.
            while(st.hasMoreTokens()){
                String path = (st.nextToken()).trim();
                InputStream in = resolveclasspathhelper(path, classname);
                if(in != null) return in;

            }
            return null;
        }
        else return (resolveclasspathhelper(classpath, classname));
    }
    

    /**
     * Returns file input stream for classfile to disassemble if exdir is set.
     */
    public InputStream resolveExdirFilenamehelper(String path, String classname){
        File fileobj = new File(path);
        if(fileobj.isDirectory()){
            // gets list of files in that directory.
            File[] filelist = fileobj.listFiles();
            for(int i = 0; i < filelist.length; i++){
                try{
                    //file is a jar file.
                    if(filelist[i].toString().endsWith(".jar")){
                        JarFile jfile = new JarFile(filelist[i]);
                        if((jfile.getEntry(classname)) != null){

                            InputStream filein = jfile.getInputStream(jfile.getEntry(classname));
                            int bytearraysize = filein.available();
                            byte []b =  new byte[bytearraysize];
                            int totalread = 0;
                            while(totalread < bytearraysize){
                                totalread += filein.read(b, totalread, bytearraysize-totalread);
                            }
                            InputStream inbyte = new ByteArrayInputStream(b);
                            filein.close();
                            return inbyte;
                        }
                    } else {
                        //not a jar file.
                        String filename = path+"/"+ classname;
                        File file = new File(filename);
                        if(file.isFile()){
                            return (new FileInputStream(file));
                        }
                    }
                }catch(FileNotFoundException fnexce){
                    fnexce.printStackTrace();
                    error("cant read file");
                    error("fatal exception");
                }catch(IOException ioexc){
                    ioexc.printStackTrace();
                    error("fatal exception");
                }
            }
        }

        return null;
    }


    /**
     * Returns file input stream for classfile to disassemble.
     */
    public InputStream resolveclasspathhelper(String path, String classname){
        File fileobj = new File(path);
        try{
            if(fileobj.isDirectory()){
                //is a directory.
                String filename = path+"/"+ classname;
                File file = new File(filename);
                if(file.isFile()){
                    return (new FileInputStream(file));
                }

            }else if(fileobj.isFile()){
                if(fileobj.toString().endsWith(".jar")){
                    //is a jar file.
                    JarFile jfile = new JarFile(fileobj);
                    if((jfile.getEntry(classname)) != null){
                        InputStream filein = jfile.getInputStream(jfile.getEntry(classname));
                        int bytearraysize = filein.available();
                        byte []b =  new byte[bytearraysize];
                        int totalread = 0;
                        while(totalread < bytearraysize){
                                totalread += filein.read(b, totalread, bytearraysize-totalread);
                        }
                        InputStream inbyte = new ByteArrayInputStream(b);
                        filein.close();
                         return inbyte;
                    }
                }
            }
        }catch(FileNotFoundException fnexce){
            fnexce.printStackTrace();
            error("cant read file");
            error("fatal exception");
        }catch(IOException ioexce){
            ioexce.printStackTrace();
            error("fatal exception");
        }
        return null;
    }
    
    
    
    protected SortedSet<String> getJarEntries(String jarname) {
    	SortedSet<String> res = new TreeSet<String>();

    	try{
    		JarFile jfile = new JarFile(jarname);
    		Enumeration<JarEntry> entries = jfile.entries();
    		while (entries.hasMoreElements()) {
    			JarEntry entry = entries.nextElement();
    			String name = entry.getName();    			
    			int classpos = name.lastIndexOf(".class");
    			if ((classpos != -1) &&
    					!PascalClassData.isInnerClass(name.substring(0, classpos)) &&
    					!entry.isDirectory()) {
    				res.add(name.substring(0, classpos));
    			}
    		}
    	}catch(FileNotFoundException fnexce){
//    		fnexce.printStackTrace();
//    		error("cant read file");
//    		error("fatal exception");
    	}catch(IOException ioexc){
//    		ioexc.printStackTrace();
//    		error("fatal exception");
    	}
    	return res;
    }


    protected SortedSet<String> getDirEntries(File fileobj, boolean includeJarEntries) {
    	SortedSet<String> res = new TreeSet<String>();

    	File[] filelist = fileobj.listFiles();
    	for(int i = 0; i < filelist.length; i++){
    		//file is a jar file.
    		String fname = filelist[i].toString();
    		if(includeJarEntries &&
    				fname.endsWith(".jar")){
    			res.addAll(getJarEntries(fname));
    		}
    		else if (fname.endsWith(".class")) {
    			int classpos = fname.lastIndexOf(".class");
    			if (classpos != -1)
    				fname = fname.substring(0, classpos);
    			if (!PascalClassData.isInnerClass(fname))
    				res.add(fname);
    		}
    	}
    	return res;
    }

    /**
     * Returns list of non-nested classes found in a path
     */
    public SortedSet<String> getExdirEntries(String path){
    	File fileobj = new File(path);
    	if(fileobj.isDirectory()){
    		return getDirEntries(fileobj,true);
    	}
    	return new TreeSet<String>();
    }

    
    /**
     * Returns list of non-nested classes found in class path
     */
    public SortedSet<String>  getClasspathEntries(String path){
        File fileobj = new File(path);
        if(fileobj.isDirectory()){
        	return getDirEntries(fileobj, false);

        }else if(fileobj.toString().endsWith(".jar")){
        	return getJarEntries(fileobj.toString());
        }
        return new TreeSet<String>();
    }

    
    /**
     * Return a list of all non-nested classes in the currently set exdir classpath
     */
    public SortedSet<String> getAllExdirEntries(){
    	SortedSet<String> res;
        if(classpath.indexOf(File.pathSeparator) != -1){
        	res = new TreeSet<String>();
            //separates path
            StringTokenizer st = new StringTokenizer(classpath, File.pathSeparator);
            while(st.hasMoreTokens()){
                String path = st.nextToken();
                res.addAll(getExdirEntries(path));
            }
        }else res = getExdirEntries(classpath);

        return res;
    }

    /**
     * Return a list of all non-nested classes in the currently set classpath
     */
    public SortedSet<String> getAllClasspathEntries(){
    	SortedSet<String> res;
        if(classpath.indexOf(File.pathSeparator) != -1){
        	res = new TreeSet<String>();
            StringTokenizer st = new StringTokenizer(classpath, File.pathSeparator);
            //separates path.
            while(st.hasMoreTokens()){
                String path = (st.nextToken()).trim();
                res.addAll(getClasspathEntries(path));
            }
        }
        else res = getClasspathEntries(classpath);
        return res;
    }


    public SortedSet<String> getAllEntries(){
    	if (extDirflag)
    	  return getAllExdirEntries();
    	else
      	  return getAllClasspathEntries();
    }
    
    
    public SortedSet<String> getClassesList(){
    	SortedSet<String> res = new TreeSet<String>();
        int searchpath = cmdboot;
        extDirflag = false;
        try{
            if(searchpath == cmdboot){
                if(bootClassPathString != null){
                    //search in specified bootclasspath.
                    classpath = bootClassPathString;
                    res.addAll(getAllEntries());
                    searchpath = cmdextdir;
                }
                else searchpath = sunboot;
            }

            if(searchpath == sunboot){
                if(System.getProperty("sun.boot.class.path") != null){
                    //search in sun.boot.class.path
                    classpath = System.getProperty("sun.boot.class.path");
                    res.addAll(getAllEntries());
                    searchpath = cmdextdir;
                }
                else searchpath = javaclass;
            }

            if(searchpath == javaclass){
                if(System.getProperty("java.class.path") != null){
                    //search in java.class.path
                    classpath =System.getProperty("java.class.path");
                    res.addAll(getAllEntries());
                    searchpath = cmdextdir;
                }
                else searchpath = cmdextdir;
            }

            if(searchpath == cmdextdir){
                if(extDirsString != null){
                    //search in specified extdir.
                    classpath = extDirsString;
                    extDirflag = true;
                    res.addAll(getAllEntries());
                    searchpath = cmdclasspath;
                    extDirflag = false;
                }
                else searchpath = javaext;
            }

            if(searchpath == javaext){
                if(System.getProperty("java.ext.dirs") != null){
                    //search in java.ext.dirs
                    classpath = System.getProperty("java.ext.dirs");
                    extDirflag = true;
                    res.addAll(getAllEntries());
                    searchpath = cmdclasspath;
                    extDirflag = false;
                }
                else searchpath = cmdclasspath;
            }
            if(searchpath == cmdclasspath){
                if(classPathString != null){
                    //search in specified classpath.
                    classpath = classPathString;
                    res.addAll(getAllEntries());
                    searchpath = 8;
                }
                else searchpath = envclasspath;
            }

            if(searchpath == envclasspath){
                if(System.getProperty("env.class.path")!= null){
                    //search in env.class.path
                    classpath = System.getProperty("env.class.path");
                    res.addAll(getAllEntries());
                    searchpath = javaclasspath;
                }
                else searchpath = javaclasspath;
            }

            if(searchpath == javaclasspath){
                if(("application.home") == null){
                    //search in java.class.path
                    classpath = System.getProperty("java.class.path");
                    res.addAll(getAllEntries());
                    searchpath = currentdir;
                }
                else searchpath = currentdir;
            }

            if(searchpath == currentdir){
                classpath = ".";
                //search in current dir.
                res.addAll(getAllEntries());
            }
        }catch(SecurityException excsec){
            excsec.printStackTrace();
            error("fatal exception");
        }catch(NullPointerException excnull){
            excnull.printStackTrace();
            error("fatal exception");
        }catch(IllegalArgumentException excill){
            excill.printStackTrace();
            error("fatal exception");
        }

        return res;
    }

    

    
}
