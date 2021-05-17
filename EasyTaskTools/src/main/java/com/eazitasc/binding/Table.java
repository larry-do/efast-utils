package com.eazitasc.binding;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import java.util.LinkedHashSet;
import java.util.List;

@Getter
@Setter
@ToString
@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class Table {
    @XmlAttribute(required = true)
    private String name;

    @XmlAttribute
    private String parent;

    @XmlAttribute(name = "abstract")
    private Boolean isAbstract;

    @XmlElement(name = "column")
    private List<Column> columns;

    @XmlElement(name = "primary-key")
    private PrimaryKey primaryKey;

    @XmlElement(name = "unique-constraint")
    private List<UniqueConstraint> uniqueConstraints;

    @XmlElement(name = "foreign-key")
    private List<ForeignKey> foreignKeys;

    @XmlTransient
    private LinkedHashSet<ForeignKey.TargetMapping> inverseMappings;

    public Column getColumn(String name) {
        if (this.columns == null) return null;
        else return this.columns.stream().filter(col -> col.getName().equalsIgnoreCase(name)).findFirst().orElse(null);
    }
}
