package z.y.x.aws;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.yaml.snakeyaml.introspector.Property;
import org.yaml.snakeyaml.nodes.NodeTuple;
import org.yaml.snakeyaml.nodes.Tag;
import org.yaml.snakeyaml.representer.Representer;



/**
 * Custom implementation of {@link Representer} and {@link Comparator} to keep
 * the needed order of javabean properties of model classes, thus generating the
 * understandable yaml
 *
 */
public class ConfigurationModelRepresenter extends Representer {

	public ConfigurationModelRepresenter() {
		super();
	}

	@Override
	protected NodeTuple representJavaBeanProperty(Object javaBean, Property property, Object propertyValue,
			Tag customTag) {
		if (propertyValue == null || propertyValue == "") {
			return null;
		} else if ("rules_egress".equals(property.getName()) || "rules".equals(property.getName()) || "volumes".equals(property.getName() )) {
			List list = (java.util.ArrayList)propertyValue;
			if(list.size()==0)
			{
				return null;
			}

		} else {
			return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
		}
		return super.representJavaBeanProperty(javaBean, property, propertyValue, customTag);
	}

	protected Set<Property> getProperties(Class<? extends Object> type) {
		Set<Property> propertySet;
		if (typeDefinitions.containsKey(type)) {
			propertySet = typeDefinitions.get(type).getProperties();
		}

		propertySet = getPropertyUtils().getProperties(type);

		List<Property> propsList = new ArrayList<>(propertySet);
		Collections.sort(propsList, new BeanPropertyComparator());

		return new LinkedHashSet<>(propsList);
	}

	class BeanPropertyComparator implements Comparator<Property> {
		public int compare(Property p1, Property p2) {
			if (p1.getType().getCanonicalName().contains("util") && !p2.getType().getCanonicalName().contains("util")) {
				return 1;
			} else if (p2.getName().endsWith("Name") || p2.getName().equalsIgnoreCase("name")) {
				return 1;
			} else {
				return -1;
			} // returning 0 would merge keys
		}
	}
}