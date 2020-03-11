package z.y.x.kube.persistentvolume;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;

import z.y.x.kube.generic.limits;
import z.y.x.kube.generic.requests;
import z.y.x.kube.generic.resources;
import z.y.x.kube.metadata;
import z.y.x.kube.hostPath;

public class Test {
	
	public static void main(String[] args) {

        
		Representer representer = new Representer() {
		    @Override
		    protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue,Tag customTag) {
		        // if value of property is null, ignore it.
		    	
		    	
		    	//System.out.println(property.getName());
		    	
		        if (propertyValue == null || propertyValue == ""  ) {
		            return null;
		        }  
		        
		        else if ("nodePort".equals(property.getName()) || "healthCheckNodePort".equals(property.getName()))
		        {
		        	 if (propertyValue !=null)
		        	 {
		        		 if(0== Integer.parseInt(propertyValue.toString()))
		        		 {
		        			 return null;
		        		 }
		        	 }
		        	 return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
		        }
		        else if("readOnly".equals(property.getName())){
		        	if (propertyValue !=null)
		        	 {		        		
		        		if (!Boolean.valueOf(propertyValue.toString())) {
							return null;
						}
		        	 }
		        	return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
		        }
		        
		        else {
		            return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
		        }
		    }
		};
		
		representer.addClassTag(PersistentVolumeClaim.class, Tag.MAP);
		representer.addClassTag(PersistentVolume.class, Tag.MAP);
		DumperOptions options = new DumperOptions();
		options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
		//options.set
		options.setPrettyFlow(true);
		
		PersistentVolumeClaimSpec spec = new PersistentVolumeClaimSpec();
		PersistentVolumeClaim pvc = new PersistentVolumeClaim();
		
		
		
		Map<String,String> annotationMap = new HashMap<>();
        annotationMap.put("ABC", "123");
        annotationMap.put("XYZ", "761");
        
        Map<String,String> labelMap = new HashMap<>();
        labelMap.put("TRT", "113");
        labelMap.put("OIU", "981");

        metadata metadata = new metadata();
        metadata.setAnnotations(annotationMap);
        metadata.setLabels(labelMap);
        metadata.setName("random");
        metadata.setNamespace("default");
        
        
        
        pvc.setMetadata(metadata);
        
        List<String> list = new ArrayList<>();
        list.add("ReadWriteOnce");
        list.add("ReadOnlyMany");
        list.add("ReadWriteMany");
        
        spec.setAccessModes(list);

        spec.setVolumeName("pv0001");
        
        limits limits = new limits();
        limits.setMemory("128Mi");
        limits.setCpu("500m");
        
        requests requests = new requests();
        requests.setCpu("500m");
        requests.setMemory("125G");
        
        
        resources resources = new resources();
        resources.setLimits(limits);
        resources.setRequests(requests);
        
        spec.setResources(resources);
        
        pvc.setSpec(spec);
		
		Yaml yaml = new Yaml(representer,options);
        String output = yaml.dump(pvc);
        
        System.out.println(output);
        
        PersistentVolume pv = new PersistentVolume();
        PersistentVolumeSpec pvs = new PersistentVolumeSpec();
        
        metadata = new metadata();
        metadata.setName("task-pv-volume");
        metadata.setNamespace("defualt");
        
        pv.setMetadata(metadata);
        
        pvs.setStorageClassName("manual");
        
        capacity capacity = new capacity();
        capacity.setStorage("10Gi");
        
        pvs.setCapacity(capacity);
        
        list = new ArrayList<>();
        list.add("ReadWriteOnce");
        list.add("ReadOnlyMany");
        list.add("ReadWriteMany");
        
        pvs.setAccessModes(list);
        
        hostPath hostPath = new hostPath();
        hostPath.setPath("/mnt/data");
        pvs.setHostPath(hostPath);
        
        pv.setSpec(pvs);
        
        output = yaml.dump(pv);
        
        System.out.println(output);

		
	}

}
