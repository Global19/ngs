# ===========================================================================
# 
#                            PUBLIC DOMAIN NOTICE
#               National Center for Biotechnology Information
# 
#  This software/database is a "United States Government Work" under the
#  terms of the United States Copyright Act.  It was written as part of
#  the author's official duties as a United States Government employee and
#  thus cannot be copyrighted.  This software/database is freely available
#  to the public for use. The National Library of Medicine and the U.S.
#  Government have not placed any restriction on its use or reproduction.
# 
#  Although all reasonable efforts have been taken to ensure the accuracy
#  and reliability of the software and data, the NLM and the U.S.
#  Government do not and cannot warrant the performance or results that
#  may be obtained by using this software or data. The NLM and the U.S.
#  Government disclaim all warranties, express or implied, including
#  warranties of performance, merchantability or fitness for any particular
#  purpose.
# 
#  Please cite the author in any work or product based on this material.
# 
# ===========================================================================
# 
# 

from ctypes import byref, c_uint32
from . import NGS

from String import NGS_String, NGS_RawString, getNGSString, getNGSValue
from FragmentIterator import FragmentIterator

    # Read
    # represents an NGS machine read
    # having some number of biological Fragments
 
class Read(FragmentIterator):
    fullyAligned     = 1
    partiallyAligned = 2
    aligned          = fullyAligned | partiallyAligned
    unaligned        = 4
    all              = aligned | unaligned

    def getReadId(self):
        return getNGSString(self, NGS.lib_manager.PY_NGS_ReadGetReadId)
            
    # ----------------------------------------------------------------------
    # Fragment
    
    def getNumFragments(self):
        return getNGSValue(self, NGS.lib_manager.PY_NGS_ReadGetNumFragments, c_uint32)

    # ----------------------------------------------------------------------
    # read details        
    
    # ReadCategory
    
    def getReadCategory(self):
        return getNGSValue(self, NGS.lib_manager.PY_NGS_ReadGetReadCategory, c_uint32)

    def getReadGroup(self):
        return getNGSString(self, NGS.lib_manager.PY_NGS_ReadGetReadGroup)
            
    def getReadName(self):
        return getNGSString(self, NGS.lib_manager.PY_NGS_ReadGetReadName)

    def getReadBases(self, offset=0, length=-1):
        """
        :param: offset is zero-based and non-negative
        :param: length must be >= 0
        :returns: sequence bases
        """
        with NGS_RawString() as ngs_str_err, NGS_String() as ngs_str_seq:
            res = NGS.lib_manager.PY_NGS_ReadGetReadBases(self.ref, offset, length, byref(ngs_str_seq.ref), byref(ngs_str_err.ref))
            return ngs_str_seq.getPyString()
        
    def getReadQualities(self, offset=0, length=-1):
        """
        :param: offset is zero-based and non-negative
        :param: length must be >= 0
        :returns: phred quality values using ASCII offset of 33
        """
        with NGS_RawString() as ngs_str_err, NGS_String() as ngs_str_seq:
            res = NGS.lib_manager.PY_NGS_ReadGetReadQualities(self.ref, offset, length, byref(ngs_str_seq.ref), byref(ngs_str_err.ref))
            return ngs_str_seq.getPyString()

