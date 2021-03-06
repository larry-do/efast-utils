package com.efasttask.util.binding;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.commons.lang3.StringUtils;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.Arrays;
import java.util.LinkedHashSet;

@Getter
@Setter
@ToString
@XmlRootElement(name = "unique-constraint")
@XmlAccessorType(XmlAccessType.FIELD)
public class UniqueConstraint {
    @XmlAttribute
    private String columns;

    public LinkedHashSet<String> getColumnsOfKey() {
        if (StringUtils.isEmpty(this.columns)) return new LinkedHashSet<>();
        else {
            return new LinkedHashSet<>(Arrays.asList(columns.replace(" ", "").split(",")));
        }
    }
}
