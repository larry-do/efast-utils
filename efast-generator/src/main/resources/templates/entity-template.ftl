package ${package};

<#list imports as import>
${import}
</#list>

<#if table.isAbstract?? && table.isAbstract>
@MappedSuperclass
<#else>
@Entity
@Table(name = "${table.name}"<#if table.uniqueConstraints?? && table.uniqueConstraints?size gt 0>, uniqueConstraints = {<#list table.uniqueConstraints as key>@UniqueConstraint(columnNames = {<#list key.getColumnsOfKey() as col>"${col}"${col?has_next?then(", ", "")}</#list>})${key?has_next?then(", ", "")}</#list>}</#if>)
</#if>
<#if table.primaryKey??>
@IdClass(${table.name?capitalize}.Pk.class)
</#if>
public<#if table.isAbstract?? && table.isAbstract> abstract</#if> class ${table.name?capitalize}<#if table.parent??> extends ${table.parent}</#if> {

    public ${table.name?capitalize}(){
    }

<#list table.columns as column>
<#if column.isPrimaryKey??!false>
    @Id
</#if>
<#list column.otherAnnotations as annotation>
    ${annotation}
</#list>
<#if column.isEnum?? && column.isEnum>
    @Enumerated(EnumType.STRING)
</#if>
    @Column(name = "${column.name}"<#if column.nullable?? && column.nullable == false>, nullable = false</#if><#if column.dbType?? && column.dbType?has_content>, columnDefinition = "${column.dbType}"</#if>)
    private ${column.jvType} ${column.name}<#if column.defaultValue??> = ${column.defaultValue}</#if>;

</#list>
<#if table.foreignKeys??>
<#list table.foreignKeys as key>
    @ManyToOne<#if key.fetch?has_content>(fetch = FetchType.${key.fetch})</#if>
    @JoinColumns({
    <#list key.columns as col>
        @JoinColumn(name="${col.name}", referencedColumnName = "${col.target}", insertable = false, updatable = false)<#if col?has_next>, </#if>
    </#list>
    })
    public ${key.target} ${key.fieldName};

</#list>
</#if>
<#if table.inverseMappings??>
<#list table.inverseMappings as mapping>
<#if mapping.orderBy?has_content>
    @OrderBy("${mapping.orderBy}")
</#if>
    @OneToMany(targetEntity = ${mapping.fromTable}.class<#if mapping.fetch?has_content>, fetch = FetchType.${mapping.fetch}</#if><#if mapping.mappedBy?has_content>, mappedBy = "${mapping.mappedBy}"</#if>)
    public List<${mapping.fromTable}> ${mapping.fieldName};

</#list>
</#if>
<#list table.columns as column>
    public ${column.jvType} get${column.name?capitalize}() {
        return this.${column.name};
    }

    public void set${column.name?capitalize}(final ${column.jvType} ${column.name}) {
        this.${column.name} = ${column.name};
    }

</#list>
<#if table.primaryKey??>
    public static class Pk implements Serializable {
    <#list table.primaryKey.getColumnsOfKey() as col>
        private ${table.getColumn(col).jvType} ${table.getColumn(col).name};

    </#list>
        public Pk(){
        }

        public Pk(<#list table.primaryKey.getColumnsOfKey() as col>${table.getColumn(col).jvType} ${table.getColumn(col).name}<#if col?has_next>, </#if></#list>) {
        <#list table.primaryKey.getColumnsOfKey() as col>
            this.${table.getColumn(col).name} = ${table.getColumn(col).name};
        </#list>
        }
    <#list table.primaryKey.getColumnsOfKey() as col>

        public ${table.getColumn(col).jvType} get${table.getColumn(col).name?capitalize}() {
            return this.${table.getColumn(col).name};
        }
    </#list>

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Pk pk = (Pk) o;
            return <#list table.primaryKey.getColumnsOfKey() as col>Objects.equals(${col}, pk.${col})${col?has_next?then(" && ", "")}</#list>;
        }

        @Override
        public int hashCode() {
            return Objects.hash(<#list table.primaryKey.getColumnsOfKey() as col>${col}${col?has_next?then(", ", "")}</#list>);
        }
    }

</#if>
}
