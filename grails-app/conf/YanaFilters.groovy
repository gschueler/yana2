import java.text.SimpleDateFormat

//import net.sf.antcontrib.net.httpclient.Params;

class YanaFilters {
	def filters = {
		
		saveValidation(controller:'nodeTypeRelationship', action:'save'){
			before = {
				params.parentCardinality=(params.parentCardinality=='*')?'999999999':params.parentCardinality
				params.childCardinality=(params.childCardinality=='*')?'999999999':params.childCardinality
			}
		}
		
		updateValidation(controller:'nodeTypeRelationship', action:'update'){
			before = {
				params.parentCardinality=(params.parentCardinality=='*')?'999999999':params.parentCardinality
				params.childCardinality=(params.childCardinality=='*')?'999999999':params.childCardinality
			}
		}
		
		childnodeEditFilter(controller:'childNode',action:'edit'){
			before = {
				if(params.parent){ params.parent=Node.get(params.parent.toLong()) }
				if(params.child){ params.child=Node.get(params.child.toLong()) }
			}
		}
		
		childnodeSaveFilter(controller:'childNode',action:'save'){
			before = {
				if(params.parent){ params.parent=params.parent.id }
				if(params.child){ params.child=params.child.id }
			}
		}
	}
}